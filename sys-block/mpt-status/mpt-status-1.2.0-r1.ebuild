# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Query tool to access the running configuration and status of LSI SCSI HBAs"
HOMEPAGE="http://www.drugphish.ch/~ratz/mpt-status/"
SRC_URI="http://www.drugphish.ch/~ratz/mpt-status/${P}.tar.bz2
	mirror://gentoo/${PN}-1.2.0-linux-sources.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.0-gentoo.patch"

	sed -i -e 's,\(^.*linux/compiler\.h.*$\),,' mpt-status.h || die
	sed -i -e '/KERNEL_PATH/d' Makefile || die

	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/{AUTHORS,Changelog,DeveloperNotes,FAQ,README,ReleaseNotes,THANKS,TODO}
}
