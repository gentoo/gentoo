# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A window manager for X in the spirit of dwm"
HOMEPAGE="https://plhk.ru/"
SRC_URI="https://plhk.ru/static/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xrandr"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gentoo.diff )

src_configure() {
	use xrandr && export MULTIHEAD=1
	sed -i -e "s|/usr/lib|/usr/$(get_libdir)|g" config.mk || die

	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs

	insinto /usr/share/${PN}
	doins {close,iconify,max}.xbm ${PN}rc

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	if ! has_version x11-misc/dmenu; then
		elog "Installing ${PN} without x11-misc/dmenu"
		elog "To have a menu you can install x11-misc/dmenu"
		elog "and use \"Echinus*spawn\" in echinusrc"
		elog "to launch dmenu_run. Check echinus documentation for details."
		elog ""
	fi
	elog "A standard config file with its pixmaps has been installed to:"
	elog "${EROOT}/usr/share/${PN}/examples"
	elog "Copy this folder to ~/.${PN}/ and modify the echinusrc as you wish."
	elog ""
	elog "For changing the modkey you can use \"Echinus*modkey: X\""
	elog "in echinusrc. Replace the X with A for ALT, W for Winkey (Super),"
	elog "S for Shift or C for the Control key."
}
