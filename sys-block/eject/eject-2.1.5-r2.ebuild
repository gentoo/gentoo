# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/eject/eject-2.1.5-r2.ebuild,v 1.1 2011/03/31 15:31:52 ssuominen Exp $

EAPI="3"

inherit eutils

DESCRIPTION="A command to eject a disc from the CD-ROM drive"
HOMEPAGE="http://eject.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.13-xmalloc.patch
	epatch "${FILESDIR}"/${PN}-2.1.4-scsi-rdwr.patch
	epatch "${FILESDIR}"/${PN}-2.1.5-handle-spaces.patch #151257
	epatch "${FILESDIR}"/${PN}-2.1.5-man-typo.patch #165248
	epatch "${FILESDIR}"/${PN}-2.1.5-toggle.patch #261880
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	# PREFIX for po/Makefile, which hardcodes a prefix of "$(DESTDIR)/usr"
	# it is not used in the other makefiles
	emake DESTDIR="${D}" PREFIX="${ED}/usr" install || die
	dodoc ChangeLog README PORTING TODO AUTHORS NEWS PROBLEMS
}
