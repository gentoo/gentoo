# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/flite/flite-1.4-r4.ebuild,v 1.9 2014/10/11 13:08:18 maekke Exp $

EAPI=5
inherit autotools eutils multilib-minimal

DESCRIPTION="Flite text to speech engine"
HOMEPAGE="http://www.speech.cs.cmu.edu/flite/index.html"
SRC_URI=" http://www.speech.cs.cmu.edu/${PN}/packed/${P}/${P}-release.tar.bz2"

LICENSE="BSD freetts public-domain regexp-UofT BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 sparc x86"
IUSE="alsa oss static-libs"

DEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-release

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
	epatch "${FILESDIR}"/${P}-tempfile.patch
	epatch "${FILESDIR}"/${P}-fix-parallel-builds.patch
	epatch "${FILESDIR}"/${P}-respect-destdir.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-audio-interface.patch
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
		rm -rf "${D}"/usr/lib*/*.a
	fi
}

pkg_postinst() {
	if [[ "$(get_audio)" = "none" ]]; then
		ewarn "you have built flite without audio support."
		ewarn "If you want audio support, re-emerge"
		ewarn "flite with alsa or oss in your use flags."
	fi
}
