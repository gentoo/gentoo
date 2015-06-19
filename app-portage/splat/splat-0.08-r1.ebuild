# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/splat/splat-0.08-r1.ebuild,v 1.7 2013/02/13 00:08:48 ago Exp $

EAPI=5

inherit eutils prefix

DESCRIPTION="Simple Portage Log Analyzer Tool"
HOMEPAGE="http://www.l8nite.net/projects/splat/"
SRC_URI="http://www.l8nite.net/projects/splat/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 ~sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify splat.pl
}

src_install() {
	newbin splat.pl splat
	dodoc ChangeLog
}
