# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Performs full/incremental backups of local/remote filesystems onto CD-R(W)s"
HOMEPAGE="https://cdbkup.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdbkup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="
	app-cdr/cdrtools
	virtual/openssh
	sys-apps/util-linux
"
RDEPEND="${DEPEND}
	!app-misc/cdcat
"

src_prepare() {
	default

	sed -i \
		-e "s:doc/cdbkup:doc/${PF}:" \
		-e 's/make /$(MAKE) /' \
		Makefile.in || die
}

src_configure() {
	econf --with-snardir=/etc/cdbkup --with-dumpgrp=users
}

src_install() {
	default
	dodoc COMPLIANCE
}
