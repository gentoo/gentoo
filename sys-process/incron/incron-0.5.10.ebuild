# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/incron/incron-0.5.10.ebuild,v 1.5 2012/11/20 01:11:48 flameeyes Exp $

EAPI="4"

inherit eutils linux-info toolchain-funcs

DESCRIPTION="inotify based cron daemon"
HOMEPAGE="http://incron.aiken.cz/"
SRC_URI="http://inotify.aiken.cz/download/incron/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

# < 2.6.18 => INOTIFY, >= 2.6.18 => INOTIFY_USER
# It should be ok to expect at least 2.6.18
CONFIG_CHECK="~INOTIFY_USER"

src_prepare() {
	epatch "${FILESDIR}"/${P}+gcc-4.7.patch
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr DOCDIR=/usr/share/doc/${PF} install

	newinitd "${FILESDIR}/incrond.init" incrond

	dodoc CHANGELOG README TODO
}
