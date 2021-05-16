# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps autotools

DESCRIPTION="generates a status bar for dzen2, xmobar or similar"
HOMEPAGE="https://i3wm.org/i3status/"
SRC_URI="https://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="pulseaudio"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/yajl-2.0.2
	dev-libs/confuse:=
	dev-libs/libnl:3
	media-libs/alsa-lib
	pulseaudio? ( || ( media-sound/pulseaudio media-sound/apulse[sdk] ) )
"

DEPEND="
	${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
"

PATCHES=(
	"${FILESDIR}/0001-Extend-battery-handling-on-OpenBSD-351.patch"
	"${FILESDIR}/0002-Fix-headers-meant-for-OpenBSD-but-snuck-in-for-FreeB.patch"
	"${FILESDIR}/0003-conditionally-compile-pulse.c-only-when-using-pulsea.patch"
	"${FILESDIR}/0004-battery-include-sys-sysctl.h-on-OpenBSD.patch"
	"${FILESDIR}/0005-configure-disable-pulse-on-OpenBSD-and-DragonFlyBSD.patch"
	"${FILESDIR}/0006-On-NetBSD-include-sys-socket.h-for-AF_INET-6.patch"
	"${FILESDIR}/0007-make-pulseaudio-an-optional-dependency-follow-best-p.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable pulseaudio)
}

src_compile() {
	pushd "${S}/${CHOST}" || die
	default
}

src_install() {
	pushd "${S}/${CHOST}" || die
	default
}

pkg_postinst() {
	fcaps cap_net_admin usr/bin/${PN}

	elog "${PN} can be used with any of the following programs:"
	elog "   i3bar (x11-wm/i3)"
	elog "   x11-misc/xmobar"
	elog "   x11-misc/dzen"
	elog "Please refer to manual: man ${PN}"
}
