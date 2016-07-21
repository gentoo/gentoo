# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PERIGRIN
MODULE_VERSION=0.4
inherit perl-module

DESCRIPTION="DOCTYPE based XML output"

LICENSE="|| ( Artistic GPL-1+ BSD )"
SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_prepare() {
	sed -i '/^auto_set_repository/d' Makefile.PL || die
	perl-module_src_prepare
}
