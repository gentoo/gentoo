# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

POSTGRES_COMPAT=( 9.{4..6} {10..11} )
POSTGRES_USEDEP="server"

inherit autotools eutils postgres-multi versionator

MY_PV=$(replace_version_separator 3 '')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="http://postgis.net"
SRC_URI="http://download.osgeo.org/postgis/source/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="address-standardizer doc gtk static-libs mapbox test topology"

RDEPEND="
	${POSTGRES_DEP}
	dev-libs/json-c:=
	dev-libs/libxml2:2
	>=sci-libs/geos-3.5.0
	>=sci-libs/proj-4.6.0
	>=sci-libs/gdal-1.10.0
	address-standardizer? ( dev-libs/libpcre )
	gtk? ( x11-libs/gtk+:2 )
	mapbox? ( dev-libs/protobuf )
"

DEPEND="${RDEPEND}
		doc? (
				app-text/docbook-xsl-stylesheets
				app-text/docbook-xml-dtd:4.5
				dev-libs/libxslt
				|| (
					media-gfx/imagemagick[png]
					media-gfx/graphicsmagick[imagemagick,png]
				)
		)
		virtual/pkgconfig
		test? ( dev-util/cunit )
"

PGIS="$(get_version_component_range 1-2)"

REQUIRED_USE="test? ( doc ) ${POSTGRES_REQ_USE}"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

MAKEOPTS+=' -j1'

# These modules are built using the same *FLAGS that were used to build
# dev-db/postgresql. The right thing to do is to ignore the current
# *FLAGS settings.
QA_FLAGS_IGNORED="usr/lib(64)?/(rt)?postgis-${PGIS}\.so"

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.2.0-arflags.patch"

	local AT_M4DIR="macros"
	eautoreconf

	postgres-multi_src_prepare
}

src_configure() {
	local myargs=""

	use gtk                  && myargs+=" --with-gui"

	use address-standardizer || myargs+=" --without-address-standardizer"
	use mapbox               || myargs+=" --without-protobuf"
	use topology             || myargs+=" --without-topology"

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
	elog "http://postgis.net/docs/manual-${PGIS}/postgis_installation.html#create_new_db_extensions"
}
