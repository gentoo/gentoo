# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( {12..15} )
POSTGRES_USEDEP="server"
inherit autotools postgres-multi toolchain-funcs

MY_P="${PN}-$(ver_rs 3 '')"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osgeo.org/gitea/postgis/postgis.git"
else
	PGIS="$(ver_cut 1-2)"
	SRC_URI="https://download.osgeo.org/postgis/source/${MY_P}.tar.gz"
	#KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	KEYWORDS=""
fi

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="https://postgis.net"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="address-standardizer doc gtk static-libs topology"

REQUIRED_USE="${POSTGRES_REQ_USE}"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

RDEPEND="${POSTGRES_DEP}
	dev-libs/json-c:=
	dev-libs/libxml2:2
	dev-libs/protobuf-c:=
	>=sci-libs/geos-3.9.0
	>=sci-libs/proj-4.9.0:=
	>=sci-libs/gdal-1.10.0:=
	address-standardizer? ( dev-libs/libpcre2 )
	gtk? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.5
		dev-libs/libxslt
		virtual/imagemagick-tools[png]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.3-try-other-cpp-names.patch"
	# source: https://github.com/google/flatbuffers/pull/7897
	#"${FILESDIR}/${PN}-3.3.2-flatbuffers-abseil-2023.patch" # bug 905378
)

src_prepare() {
	default

	if [[ ${PV} = *9999* ]] ; then
		source "${S}"/Version.config
		PGIS="${POSTGIS_MAJOR_VERSION}.${POSTGIS_MINOR_VERSION}"
	fi

	# These modules are built using the same *FLAGS that were used to build
	# dev-db/postgresql. The right thing to do is to ignore the current
	# *FLAGS settings.
	QA_FLAGS_IGNORED="usr/lib(64)?/(rt)?postgis-${PGIS}\.so"

	# bug #775968
	touch build-aux/ar-lib || die

	local AT_M4DIR="macros"
	eautoreconf

	postgres-multi_src_prepare
}

src_configure() {
	export CPP=$(tc-getCPP)

	local myeconfargs=(
		$(use_with address-standardizer)
		$(use_with gtk gui)
		$(use_with topology)
	)
	postgres-multi_foreach econf "${myeconfargs[@]}"
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

	local base_uri="https://postgis.net/docs/manual-"
	if [[ ${PV} = *9999* ]] ; then
		base_uri+="dev"
	else
		base_uri+="${PGIS}"
	fi

	elog "To finish installing PostGIS, follow the directions detailed at:"
	elog "${base_uri}/postgis_installation.html#create_new_db_extensions"
}
