# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN="wmspaceweather"
MY_PV_ORIG="${PV/_p*}"
MY_PV_PATCH="${PV/_p/-}"
MY_P_ORIG="${MY_PN}_${MY_PV_ORIG}.orig"
MY_P_PATCH="${MY_PN}_${MY_PV_PATCH}.diff"

DESCRIPTION="dockapp showing weather at geosynchronous orbit"
HOMEPAGE="https://www.dockapps.net/wmspaceweather"
SRC_URI="mirror://debian/pool/main/w/${MY_PN}/${MY_P_ORIG}.tar.gz
	    mirror://debian/pool/main/w/${MY_PN}/${MY_P_PATCH}.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86"

DOCS=( ../{BUGS,CHANGES,HINTS,README} )

CDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${CDEPEND}
	x11-base/xorg-proto"
RDEPEND="${CDEPEND}
	net-misc/curl
	dev-lang/perl"

S="${WORKDIR}/${MY_P_ORIG/_/-}/${PN}"

src_prepare() {
	default

	cd .. || die

	eapply "${WORKDIR}"/${MY_P_PATCH}
	eapply "${FILESDIR}"/${P}-gcc-10.patch

	# need to apply patches from Debian first, do NOT change the order
	cd "${S}" || die
	eapply -p2 ../debian/patches/*.dpatch
	eapply "${FILESDIR}"/${P}-gentoo.patch
	eapply "${FILESDIR}"/${P}-getkp.patch
}

src_compile() {
	emake clean
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}

pkg_postinst() {
	elog "You need to emerge www-client/firefox or www-client/firefox-bin"
	elog "to use the -url functionality - see man ${PN} for more info."
	elog
	elog "This version uses curl instead of wget. You may edit /usr/share/wmspaceweather/GetKp"
	elog "if you don't like it."
}
