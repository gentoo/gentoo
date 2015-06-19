# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/suite3270/suite3270-3.3.7_p8.ebuild,v 1.2 2009/12/15 19:28:38 ssuominen Exp $

inherit eutils

IUSE="cjk doc ncurses ssl tcl X"

S="${WORKDIR}"
DESCRIPTION="Complete 3270 access package"
SRC_URI="http://x3270.bgp.nu/download/${PN}-${PV/_/}.tgz"
HOMEPAGE="http://x3270.bgp.nu/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"

RDEPEND="X? ( x11-libs/libX11
			  x11-libs/libXaw
			  x11-libs/libXmu
			  x11-libs/libXt )
		 cjk? ( dev-libs/icu )
		 ncurses? ( sys-libs/ncurses
					sys-libs/readline )
		 ssl? ( dev-libs/openssl )
		 tcl? ( dev-lang/tcl )"

DEPEND="${RDEPEND}
		X? ( x11-misc/imake
			 x11-misc/xbitmaps
			 x11-proto/xproto
			 app-text/rman
			 x11-apps/mkfontdir
			 x11-apps/bdftopcf )"

SUB_PV="3.3"
MY_FONTDIR="/usr/share/fonts/x3270"

suite3270_makelist() {
	MY_PLIST="pr3287 s3270"
	use ncurses && MY_PLIST="${MY_PLIST} c3270"
	use tcl && MY_PLIST="${MY_PLIST} tcl3270"
	use X && MY_PLIST="${MY_PLIST} x3270"
}

src_compile() {
	local myconf

	myconf="--without-pr3287"
	myconf="${myconf} --cache-file=${S}/config.cache"
	myconf="${myconf} $(use_enable cjk dbcs)"
	myconf="${myconf} $(use_enable ssl)"
	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_with X fontdir ${MY_FONTDIR})"

	suite3270_makelist
	for p in ${MY_PLIST} ; do
		cd "${S}/${p}-${SUB_PV}"
		econf ${myconf} || die "econf failed on ${p}"
		emake || die "emake faild on ${p}"
	done
}

src_install () {
	suite3270_makelist
	use X && dodir ${MY_FONTDIR}
	for p in ${MY_PLIST} ; do
		cd "${S}/${p}-${SUB_PV}"
		emake DESTDIR="${D}" install install.man \
			|| die "emake failed on ${p}"
		use doc && docinto ${p} && dohtml html/*
	done

	use X && rm -f "${D}/${MY_FONTDIR}/fonts.dir"
	return 0
}

pkg_postinst() {
	if use X ; then
		einfo "Running mkfontdir on ${MY_FONTDIR}"
		mkfontdir ${MY_FONTDIR}
	fi
}
