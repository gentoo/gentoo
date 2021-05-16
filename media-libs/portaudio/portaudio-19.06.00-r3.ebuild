# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A free, cross-platform, open-source, audio I/O library"
HOMEPAGE="http://www.portaudio.com/"
SRC_URI="http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
	https://sources.debian.org/data/main/p/portaudio19/19.6.0-1/debian/patches/audacity-portmixer.patch -> ${PN}-19.06.00-audacity-portmixer.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="alsa +cxx debug doc jack oss static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}"

DOCS=( README.txt )

PATCHES=(
	"${DISTDIR}/${PN}-19.06.00-audacity-portmixer.patch"
	"${FILESDIR}"/${PN}-19.06.00-AR.patch # bug #720966, trigger reconf
	"${FILESDIR}"/${PN}-19.06.00-slibtool.patch
)

src_prepare() {
	default

	eautoconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output)
		$(use_enable cxx)
		$(use_enable static-libs static)
		$(use_with alsa)
		$(use_with jack)
		$(use_with oss)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	# workaround parallel build issue
	emake lib/libportaudio.la
	emake
}

src_compile() {
	multilib-minimal_src_compile

	if use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
	fi
}

multilib_src_install_all() {
	default

	use doc && dodoc -r doc/html

	find "${ED}" -name "*.la" -delete || die
}
