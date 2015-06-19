# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2_Driver_mssql/PEAR-MDB2_Driver_mssql-1.5.0_beta3.ebuild,v 1.8 2014/01/26 18:33:36 olemarkus Exp $

EAPI="2"

inherit php-pear-r1

DESCRIPTION="Database Abstraction Layer, mssql driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=dev-php/PEAR-MDB2-2.5.0_beta3
		dev-lang/php[mssql]"
RDEPEND="${DEPEND}"
