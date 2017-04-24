# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PEAR_PV=${PV/_beta/b}

inherit php-pear-r2

DESCRIPTION="Database Abstraction Layer, oci8 driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-MDB2-2.5.0_beta3
	dev-lang/php:*[oci8-instant-client(-)]"
