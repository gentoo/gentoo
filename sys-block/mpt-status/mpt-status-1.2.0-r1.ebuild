# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Query tool to access the running configuration and status of LSI SCSI HBAs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${PN}-1.2.0-linux-sources.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	default

	eapply "${FILESDIR}/${PN}-1.2.0-gentoo.patch"

	sed -i -e 's,\(^.*linux/compiler\.h.*$\),,' mpt-status.h || die
	sed -i -e '/KERNEL_PATH/d' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	dodoc doc/{AUTHORS,Changelog,DeveloperNotes,FAQ,README,ReleaseNotes,THANKS,TODO}
}
