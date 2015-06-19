# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/rsnapshot/rsnapshot-1.3.1.ebuild,v 1.6 2009/01/10 17:08:01 klausman Exp $

inherit eutils

DESCRIPTION="A filesystem backup utility based on rsync"
HOMEPAGE="http://www.rsnapshot.org"
SRC_URI="http://www.rsnapshot.org/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.2
		>=sys-apps/util-linux-2.12-r4
		>=sys-apps/coreutils-5.0.91-r4
		>=net-misc/openssh-3.7.1_p2-r1
		>=net-misc/rsync-2.6.0"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-cp_al.patch
}

src_compile() {
	econf --prefix=/usr --sysconfdir=/etc || die
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"

	dodoc INSTALL README AUTHORS TODO ChangeLog docs/*
	insinto /usr/share/doc/${PF}/HOWTOs
	doins docs/HOWTOs/*
	docinto utils
	dodoc utils/{README,rsnaptar,*.sh}
	docinto utils/rsnapshotdb
	dodoc utils/rsnapshotdb/*
}

pkg_postinst() {
	elog
	elog "The configuration file: /etc/rsnapshot.conf.default "
	elog "  has been installed. "
	elog "This is a template. "
	elog "Copy, or move, the above file to: /etc/rsnapshot.conf "
	elog "Note that upgrading will update the template, not real config. "
	elog
}
