# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{4..6} 10 )
POSTGRES_USEDEP="server"

inherit postgres-multi

DESCRIPTION="R language extension for postgresql database"
HOMEPAGE="http://www.joeconway.com/plr/"
SRC_URI="https://github.com/postgres-plr/plr/archive/REL${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/R
	${POSTGRES_DEP}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="${POSTGRES_REQ_USE}"

S=${WORKDIR}/contrib/${PN}

src_unpack() {
	unpack ${A}
	# the build system wants 'contrib' to be part of the path
	mkdir -p "${WORKDIR}/contrib"
	mv "${WORKDIR}/${PN}-REL${PV//./_}" "${S}"
}

src_prepare() {
	local BUILD_DIR="${S}"
	postgres-multi_src_prepare
}

src_compile() {
	pg_src_compile() {
		cd "${BUILD_DIR}"
		PG_CONFIG="${SYSROOT}${EPREFIX}/usr/$(get_libdir)/postgresql-${MULTIBUILD_ID}/bin/pg_config" \
		USE_PGXS=1 \
		emake -j1
	}
	postgres-multi_foreach pg_src_compile
}

src_install() {
	pg_src_install() {
		cd "${BUILD_DIR}"
		PG_CONFIG="${SYSROOT}${EPREFIX}/usr/$(get_libdir)/postgresql-${MULTIBUILD_ID}/bin/pg_config" \
		USE_PGXS=1 \
		emake -j1 DESTDIR="${D}" install
	}
	postgres-multi_foreach pg_src_install
}

pkg_postinst() {
	elog "The plr extension needs to be explicitly added (or 'created') on each database"
	elog "you wish to use it with.  As of postgresql-9.1 the easiest way to do this is"
	elog "with the proprietary SQL statement:"
	elog
	elog "\tCREATE EXTENSION plr;"
	elog
	elog "For more info on how to add PL/R to your postgresql database(s), please visit"
	elog "http://www.joeconway.com/doc/plr-install.html"
}
