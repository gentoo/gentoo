# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

MY_PV="${PV//_/}"

DESCRIPTION="Simple EWMH compatible window manager with titlebars and frames"
HOMEPAGE="https://github.com/segin/matwm2"
SRC_URI="https://github.com/segin/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug xft xinerama"

RDEPEND="
	x11-libs/libXext
	x11-libs/libX11
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-destdir-fix.patch )

src_prepare() {
	default

	# Let the package manager handle stripping
	sed -e 's/install -s/install/g' -i Makefile.in || die
}

src_configure() {
	# configure is not autotools based
	local myconfigureargs=(
		--prefix="${EPREFIX}/usr"
		--mandir="${EPREFIX}/usr/share/man"
		--cc="$(tc-getCC)"
		$(usev debug --enable-debug)
		$(usev !xft --disable-xft)
		$(usev !xinerama --disable-xinerama)
	)

	edo ./configure "${myconfigureargs[@]}"
}

src_install() {
	default

	docompress -x /usr/share/doc/${PF}/default_matwmrc
	dodoc default_matwmrc

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	exeinto /etc/X11/Sessions
	newexe - ${PN} <<-EOF
	#!/bin/sh
	${PN}
	EOF
}
