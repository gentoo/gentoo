# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-UUlib/Convert-UUlib-1.400.0-r2.ebuild,v 1.2 2014/10/11 20:20:41 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="A Perl interface to the uulib library"

LICENSE="Artistic GPL-2" # needs both
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-unbundle.patch" )

RDEPEND=">=dev-libs/uulib-0.5.20-r1"
DEPEND="${RDEPEND}"

SRC_TEST="do"
