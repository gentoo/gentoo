# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
POSTGRES_COMPAT=( 9.{3..6} 10 )
POSTGRES_USEDEP="server"

inherit autotools eutils postgres-multi subversion versionator

MY_PV=$(replace_version_separator 3 '')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

ESVN_REPO_URI="http://svn.osgeo.org/postgis/trunk/"

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="http://postgis.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc gtk static-libs test"

RDEPEND="
	${POSTGRES_DEP}
	dev-libs/json-c
	dev-libs/libxml2:2
	>=sci-libs/geos-3.4.2
	>=sci-libs/proj-4.6.0
	>=sci-libs/gdal-1.10.0:=
	gtk? ( x11-libs/gtk+:2 )
"

DEPEND="${RDEPEND}
		doc? (
				app-text/docbook-xsl-stylesheets
				app-text/docbook-xml-dtd:4.5
				dev-libs/libxslt
				virtual/imagemagick-tools[png]
		)
		virtual/pkgconfig
		test? ( dev-util/cunit )
"

REQUIRED_USE="test? ( doc )"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

MAKEOPTS+=' -j1'

src_prepare() {
	source "${S}"/Version.config
	export PGIS="${POSTGIS_MAJOR_VERSION}.${POSTGIS_MINOR_VERSION}"

	# These modules are built using the same *FLAGS that were used to build
	# dev-db/postgresql. The right thing to do is to ignore the current
	# *FLAGS settings.
	export QA_FLAGS_IGNORED="usr/lib(64)?/(rt)?postgis-${PGIS}\.so"

	eapply_user

	local AT_M4DIR="macros"
	eautoreconf
	postgres-multi_src_prepare
}

src_configure() {
	local myargs=""
	use gtk && myargs+=" --with-gui"
	postgres-multi_foreach econf ${myargs}
}

src_compile() {
	postgres-multi_foreach emake
	postgres-multi_foreach emake -C topology

	if use doc ; then
		postgres-multi_foreach emake comments
		postgres-multi_foreach emake cheatsheets
		postgres-multi_forbest emake -C doc html
	fi
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install
	postgres-multi_foreach emake -C topology DESTDIR="${D}" install
	postgres-multi_forbest dobin ./utils/postgis_restore.pl

	dodoc CREDITS TODO loader/README.* doc/*txt

	docinto topology
	dodoc topology/{TODO,README}

	if use doc ; then
		postgres-multi_foreach emake DESTDIR="${D}" comments-install

		docinto html
		postgres-multi_forbest dodoc doc/html/{postgis.html,style.css}

		docinto html/images
		postgres-multi_forbest dodoc doc/html/images/*
	fi

	use static-libs || find "${ED}" -name '*.a' -delete
}

pkg_postinst() {
	ebegin "Refreshing PostgreSQL symlinks"
	postgresql-config update
	eend $?

	elog "To finish installing PostGIS, follow the directions detailed at:"
	elog "http://postgis.net/docs/manual-dev/postgis_installation.html#create_new_db_extensions"
}
