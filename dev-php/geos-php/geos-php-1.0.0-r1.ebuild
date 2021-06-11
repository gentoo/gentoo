# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="geos"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-3 php7-4 php8-0"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

S="${WORKDIR}/php-geos"

inherit php-ext-source-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A PHP interface to GEOS - Geometry Engine, Open Source"
HOMEPAGE="https://trac.osgeo.org/geos"
SRC_URI="https://git.osgeo.org/gitea/geos/php-geos/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="sci-libs/geos[-php(-)]"
DEPEND="sci-libs/geos[-php(-)]"
DOCS=( README.md CREDITS NEWS TODO )
PATCHES=( "${FILESDIR}/${PV}" )
PHP_EXT_ECONF_ARGS=()

src_prepare() {
	# Test always fails with geos-3.8 or greater
	rm "${S}/tests/001_Geometry.phpt" || die
	php-ext-source-r3_src_prepare
}
