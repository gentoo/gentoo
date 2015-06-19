# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgrouting/pgrouting-2.0.0.ebuild,v 1.2 2014/12/28 15:11:49 titanofold Exp $

EAPI="5"
POSTGRES_COMPAT=( 9.{0,1,2,3,4} )

inherit eutils cmake-utils

DESCRIPTION="pgRouting extends PostGIS and PostgreSQL with geospatial routing functionality."
HOMEPAGE="http://pgrouting.org/index.html"
LICENSE="GPL-2 MIT Boost-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/pgRouting/pgrouting/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
IUSE="+drivingdistance doc pdf html"

REQUIRED_USE="html? ( doc ) pdf? ( doc )"

RDEPEND="
	|| (
		dev-db/postgresql:9.4[server]
		dev-db/postgresql:9.3[server]
		dev-db/postgresql:9.2[server]
		dev-db/postgresql:9.1[server]
		dev-db/postgresql:9.0[server]
	)
	>=dev-db/postgis-2.0
	dev-libs/boost
	drivingdistance? ( sci-mathematics/cgal )
"

DEPEND="
	doc? ( >=dev-python/sphinx-1.1 )
	pdf? ( >=dev-python/sphinx-1.1[latex] )
"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"
CMAKE_MIN_VERSION="2.8.8"

postgres_check_slot() {
	if ! declare -p POSTGRES_COMPAT &>/dev/null; then
		die 'POSTGRES_COMPAT not declared.'
	fi

# Don't die because we can't run postgresql-config during pretend.
[[ "$EBUILD_PHASE" = "pretend" \
	&& -z "$(which postgresql-config 2> /dev/null)" ]] && return 0

	local res=$(echo ${POSTGRES_COMPAT[@]} \
		| grep -c $(postgresql-config show 2> /dev/null) 2> /dev/null)

	if [[ "$res" -eq "0" ]] ; then
			eerror "PostgreSQL slot must be set to one of: "
			eerror "    ${POSTGRES_COMPAT[@]}"
			return 1
	fi

	return 0
}

pkg_pretend() {
	postgres_check_slot || die
}

pkg_setup() {
	postgres_check_slot || die
}

src_prepare() {
	epatch "${FILESDIR}/no-contrib-when-use-extension.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with drivingdistance DD)
		$(cmake-utils_use_with doc DOC)
		$(cmake-utils_use_build doc MAN)
		$(cmake-utils_use_build html HTML)
		$(cmake-utils_use_build pdf LATEX)
	)

	cmake-utils_src_configure
}

src_compile() {
	local make_opts
	use doc && make_opts="all doc"
	cmake-utils_src_make ${make_opts}
}

src_install() {
	use doc && doman "${BUILD_DIR}"/doc/man/en/pgrouting.7
	use html && dohtml -r "${BUILD_DIR}"/doc/html/*
	use pdf && dodoc "${BUILD_DIR}"/doc/latex/en/*.pdf

	dodoc README* VERSION

	cmake-utils_src_install
}
