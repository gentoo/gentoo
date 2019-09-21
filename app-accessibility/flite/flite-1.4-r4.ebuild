# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="Flite text to speech engine"
HOMEPAGE="http://www.speech.cs.cmu.edu/flite/index.html"
SRC_URI=" http://www.speech.cs.cmu.edu/${PN}/packed/${P}/${P}-release.tar.bz2"

LICENSE="BSD freetts public-domain regexp-UofT BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ppc ppc64 sparc x86"
IUSE="alsa oss static-libs"

DEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-release

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-tempfile.patch
	"${FILESDIR}"/${PN}-1.4-fix-parallel-builds.patch
	"${FILESDIR}"/${PN}-1.4-respect-destdir.patch
	"${FILESDIR}"/${PN}-1.4-ldflags.patch
	"${FILESDIR}"/${PN}-1.4-audio-interface.patch
)

get_audio() {
	if use alsa; then
		echo alsa
	elif use oss; then
		echo oss
	else
		echo none
	fi
}

src_prepare() {
	default

	sed -i main/Makefile \
		-e '/-rpath/s|$(LIBDIR)|$(INSTALLLIBDIR)|g' \
		|| die
	eautoreconf

	# custom makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=()
	if ! use static-libs; then
		myconf+=( --enable-shared )
	fi
	myconf+=( --with-audio=$(get_audio) )

	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

multilib_src_install_all() {
	dodoc ACKNOWLEDGEMENTS README

	if ! use static-libs; then
		find "${ED}" -name '*.a' ! -name '*.dll.a' -delete || die
	fi
}

pkg_postinst() {
	if [[ "$(get_audio)" = "none" ]]; then
		ewarn "you have built flite without audio support."
		ewarn "If you want audio support, re-emerge"
		ewarn "flite with alsa or oss in your use flags."
	fi
}
