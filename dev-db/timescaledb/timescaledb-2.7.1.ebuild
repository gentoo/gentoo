# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 12 13 14 )
POSTGRES_USEDEP="ssl"

inherit postgres-multi cmake

DESCRIPTION="Open-source time-series SQL database"
HOMEPAGE="https://www.timescale.com/"
SRC_URI="https://github.com/timescale/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE="proprietary-extensions"
LICENSE="POSTGRESQL Apache-2.0 proprietary-extensions? ( timescale )"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

CMAKE_IN_SOURCE_BUILD=yes
CMAKE_BUILD_TYPE="RelWithDebInfo"
BUILD_DIR=${WORKDIR}/${P}

src_prepare() {
	postgres-multi_src_prepare
	postgres-multi_foreach cmake_src_prepare
}

timescale_configure() {
	local CMAKE_USE_DIR=$BUILD_DIR
	local mycmakeargs=( "-DPG_CONFIG=/usr/bin/pg_config${MULTIBUILD_VARIANT}" "-DREGRESS_CHECKS=OFF" )

	# licensing is tied to features, this useflag disables the non-apache2 licensed bits
	if ! use proprietary-extensions ; then
		mycmakeargs+=("-DAPACHE_ONLY=ON")
	fi
	cmake_src_configure
}

src_configure() {
	postgres-multi_foreach timescale_configure
}

timescale_src_compile() {
	local CMAKE_USE_DIR=$BUILD_DIR
	cmake_src_compile
}

src_compile() {
	postgres-multi_foreach timescale_src_compile
}

timescale_src_install() {
	local CMAKE_USE_DIR=$BUILD_DIR
	cmake_src_install
}

src_install() {
	postgres-multi_foreach timescale_src_install
}
