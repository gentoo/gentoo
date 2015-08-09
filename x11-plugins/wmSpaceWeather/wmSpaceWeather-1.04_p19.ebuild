# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

MY_PN="wmspaceweather"
MY_PV_ORIG="${PV/_p*}"
MY_PV_PATCH="${PV/_p/-}"
MY_P_ORIG="${MY_PN}_${MY_PV_ORIG}.orig"
MY_P_PATCH="${MY_PN}_${MY_PV_PATCH}.diff"

DESCRIPTION="dockapp showing weather at geosynchronous orbit"
HOMEPAGE="http://packages.debian.org/sid/wmspaceweather"
SRC_URI="mirror://debian/pool/main/w/${MY_PN}/${MY_P_ORIG}.tar.gz
	    mirror://debian/pool/main/w/${MY_PN}/${MY_P_PATCH}.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ~mips ppc sparc x86"
IUSE=""

CDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${CDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"
RDEPEND="${CDEPEND}
	net-misc/curl
	dev-lang/perl"

S="${WORKDIR}/${MY_P_ORIG/_/-}/${PN}"

src_unpack() {
	unpack ${MY_P_ORIG}.tar.gz
	epatch "${DISTDIR}"/${MY_P_PATCH}.gz

	# need to apply patches from Debian first, do NOT change the order
	cd "${S}"
	mv ../debian/patches "${WORKDIR}"/patch
	EPATCH_SUFFIX="dpatch" EPATCH_FORCE="yes" \
		EPATCH_MULTI_MSG="Applying Debian patches ..." epatch
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-getkp.patch
}

src_compile() {
	emake clean || die "make clean failed"
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "parallel make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die install failed
	dodoc ../{BUGS,CHANGES,HINTS,README}
}

pkg_postinst() {
	elog "You need to emerge www-client/firefox or www-client/firefox-bin"
	elog "to use the -url functionality - see man ${PN} for more info."
	elog
	elog "This version uses curl instead of wget. You may edit /usr/share/wmspaceweather/GetKp"
	elog "if you don't like it."
}
