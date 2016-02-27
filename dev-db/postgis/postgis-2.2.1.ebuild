# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
POSTGRES_COMPAT=( 9.{1,2,3,4,5} )

inherit autotools eutils versionator

MY_PV=$(replace_version_separator 3 '')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="http://postgis.net"
SRC_URI="http://download.osgeo.org/postgis/source/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc gtk static-libs test"

RDEPEND="
		|| (
			dev-db/postgresql:9.5[server]
			dev-db/postgresql:9.4[server]
			dev-db/postgresql:9.3[server]
			dev-db/postgresql:9.2[server]
			dev-db/postgresql:9.1[server]
		)
		dev-libs/json-c
		dev-libs/libxml2:2
		>=sci-libs/geos-3.5.0
		>=sci-libs/proj-4.6.0
		>=sci-libs/gdal-1.10.0
		gtk? ( x11-libs/gtk+:2 )
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

REQUIRED_USE="test? ( doc )"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

MAKEOPTS+=' -j1'

# These modules are built using the same *FLAGS that were used to build
# dev-db/postgresql. The right thing to do is to ignore the current
# *FLAGS settings.
QA_FLAGS_IGNORED="usr/lib(64)?/(rt)?postgis-${PGIS}\.so"

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
	export PGSLOT="$(postgresql-config show)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.2.0-arflags.patch"

	local AT_M4DIR="macros"
	eautoreconf
}

src_configure() {
	local myargs=""
	use gtk && myargs+=" --with-gui"
	econf \
		--with-pgconfig="/usr/lib/postgresql-${PGSLOT}/bin/pg_config" \
		${myargs}
}

src_compile() {
	emake
	emake -C topology

	if use doc ; then
		emake comments
		emake cheatsheets
		emake -C doc html
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake DESTDIR="${D}" comments-install
	emake -C topology DESTDIR="${D}" install
	dobin ./utils/postgis_restore.pl

	dodoc CREDITS TODO loader/README.* doc/*txt

	use doc && dohtml -r doc/html/*

	docinto topology
	dodoc topology/{TODO,README}

	use static-libs || find "${ED}" -name '*.a' -delete
}

pkg_postinst() {
	postgresql-config update

	elog "To finish installing PostGIS, follow the directions detailed at:"
	elog "http://postgis.net/docs/manual-${MY_PV}/postgis_installation.html#create_new_db_extensions"
}
