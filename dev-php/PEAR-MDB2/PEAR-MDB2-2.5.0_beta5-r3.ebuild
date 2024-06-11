# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PEAR_PV=${PV/_beta/b}

inherit php-pear-r2

DESCRIPTION="Database Abstraction Layer"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~s390 ~sparc ~x86"
IUSE="mssql mysql mysqli postgres sqlite"

RDEPEND="dev-php/PEAR-PEAR"

PDEPEND="mssql? ( dev-php/PEAR-MDB2_Driver_mssql )
	mysql? ( dev-php/PEAR-MDB2_Driver_mysqli )
	mysqli? ( dev-php/PEAR-MDB2_Driver_mysqli )
	postgres? ( dev-php/PEAR-MDB2_Driver_pgsql )"

DOCS=( docs/{CONTRIBUTORS,MAINTAINERS,README,STATUS,TODO} )
HTML_DOCS=( docs/datatypes.html )
