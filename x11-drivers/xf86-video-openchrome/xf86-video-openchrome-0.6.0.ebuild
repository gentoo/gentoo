# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_DRI="always"
inherit xorg-2

DESCRIPTION="X.Org driver for VIA/S3G cards"
HOMEPAGE="https://www.freedesktop.org/wiki/Openchrome/"
LICENSE="MIT"

KEYWORDS="amd64 x86"
IUSE="debug viaregtool"

RDEPEND=">=x11-base/xorg-server-1.9"
DEPEND="
	${RDEPEND}
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXv
	x11-libs/libXvMC
	x11-libs/libdrm
"

DOCS=( ChangeLog NEWS README )

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable debug xv-debug)
		$(use_enable viaregtool)
	)
	xorg-2_src_configure
}

pkg_postinst() {
	xorg-2_pkg_postinst

	elog "Supported chipsets:"
	elog "CLE266 (VT3122), KM400/P4M800 (VT3205), K8M800 (VT3204),"
	elog "PM800/PM880/CN400 (VT3259), VM800/CN700/P4M800Pro (VT3314),"
	elog "CX700 (VT3324), P4M890 (VT3327), K8M890 (VT3336),"
	elog "P4M900/VN896 (VT3364), VX800 (VT3353), VX855 (VT3409), VX900"
	elog
	elog "The driver name is 'openchrome', and this is what you need"
	elog "to use in your xorg.conf (and not 'via')."
	elog
	elog "See the ChangeLog and release notes for more information."
}
