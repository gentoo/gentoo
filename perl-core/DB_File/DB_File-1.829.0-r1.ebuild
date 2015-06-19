# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/DB_File/DB_File-1.829.0-r1.ebuild,v 1.2 2015/06/04 17:14:14 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PMQS
MODULE_VERSION=1.829
inherit perl-module multilib eutils

DESCRIPTION="A Berkeley DB Support Perl Module"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-libs/db:*"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_prepare() {
	if [[ $(get_libdir) != "lib" ]] ; then
		sed -i "s:^LIB.*:LIB = /usr/$(get_libdir):" "${S}"/config.in || die
	fi
}
