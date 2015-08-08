# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CBARRATT
MODULE_VERSION=0.70
inherit perl-module

DESCRIPTION="An rsync perl module"
HOMEPAGE="http://perlrsync.sourceforge.net/ ${HOMEPAGE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="net-misc/rsync"

PATCHES=( "${FILESDIR}/${P}-make.patch" )

src_prepare() {
	perl-module_src_prepare
	tc-export CC
}
