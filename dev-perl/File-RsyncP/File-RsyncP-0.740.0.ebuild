# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-RsyncP/File-RsyncP-0.740.0.ebuild,v 1.1 2015/06/20 23:21:32 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CBARRATT
MODULE_VERSION=0.74
inherit perl-module

DESCRIPTION="An rsync perl module"
HOMEPAGE="http://perlrsync.sourceforge.net/ ${HOMEPAGE}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="net-misc/rsync"

PATCHES=( "${FILESDIR}/${PN}-0.700.0-make.patch" )

src_prepare() {
	perl-module_src_prepare
	tc-export CC
}

SRC_TEST="do parallel"
