# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PEAR_PV=${PV/_beta/b}

inherit php-pear-r2

DESCRIPTION="Database Abstraction Layer, mysqli driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-MDB2-2.5.0_beta3
	dev-lang/php:*[mysqli(-)]"
