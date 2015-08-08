# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Spindown is a daemon that can spin down idle disks"
HOMEPAGE="http://code.google.com/p/spindown"
SRC_URI="http://spindown.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/sg3_utils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-CFLAGS-LDFLAGS.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	insinto /etc
	newins spindown.conf.example spindown.conf
	newinitd "${FILESDIR}"/spindownd.initd-r1 spindownd
	newconfd "${FILESDIR}"/spindownd.confd-r1 spindownd
	dosbin spindownd
	dodoc CHANGELOG README TODO spindown.conf.example
}

pkg_postinst() {
	elog "Before starting spindownd the first time"
	elog "you should modify /etc/spindown.conf"
	elog
	elog "To start spindownd by default"
	elog "you should add it to the default runlevel:"
	elog "  rc-update add spindownd default"
}
