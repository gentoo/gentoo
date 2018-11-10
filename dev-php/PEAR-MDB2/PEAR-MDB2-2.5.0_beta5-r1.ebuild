# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PEAR_PV=${PV/_beta/b}

inherit php-pear-r2

DESCRIPTION="Database Abstraction Layer"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="mssql mysql mysqli oci8 oci8-instant-client postgres sqlite"

RDEPEND=">=dev-php/PEAR-PEAR-1.9.1"

PDEPEND="mssql? ( >=dev-php/PEAR-MDB2_Driver_mssql-1.3.0_beta4 )
	mysql? ( >=dev-php/PEAR-MDB2_Driver_mysql-1.5.0_beta4 )
	mysqli? ( >=dev-php/PEAR-MDB2_Driver_mysqli-1.5.0_beta4 )
	oci8? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_beta4 )
	oci8-instant-client? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_beta4 )
	postgres? ( >=dev-php/PEAR-MDB2_Driver_pgsql-1.5.0_beta4 )"

DOCS=( docs/CONTRIBUTORS docs/MAINTAINERS docs/README docs/STATUS docs/TODO )
HTML_DOCS=( docs/datatypes.html)
