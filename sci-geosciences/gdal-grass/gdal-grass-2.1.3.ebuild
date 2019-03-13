# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GDAL plugin to access GRASS data"
HOMEPAGE="https://www.gdal.org/"
SRC_URI="https://download.osgeo.org/gdal/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

IUSE="postgres"
RDEPEND="
	>=sci-libs/gdal-2.0.0:=
	sci-geosciences/grass:=
"
DEPEND="${RDEPEND}
	postgres? ( dev-db/postgresql )"

# these drivers are copied at install from the already installed GRASS
QA_PREBUILT="/usr/share/gdal/grass/driver/db/*"

src_prepare() {
	sed -e 's:mkdir ${GRASSTABLES_DIR}$:mkdir -p ${GRASSTABLES_DIR}:' \
		-i Makefile.in || die
	default
}

src_configure() {
	local grassp=$(best_version sci-geosciences/grass)
	local grasspv=$(echo ${grassp/%-r[0-9]*/} | rev | cut -d - -f 1 | rev)
	local grasspm=$(ver_cut 1-2 ${grasspv})
	local myeconfargs=(
		--with-grass="/usr/$(get_libdir)/grass$(ver_rs 1 '' ${grasspm})"
		--with-gdal="/usr/bin/gdal-config"
		$(use_with postgres postgres-includes "/usr/include/postgresql")
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	#pass the right variables to 'make install' to prevent a sandbox access violation
	emake DESTDIR="${D}" \
		GRASSTABLES_DIR="${D}$(gdal-config --prefix)/share/gdal/grass" \
		AUTOLOAD_DIR="${D}/usr/$(get_libdir)/gdalplugins" \
		install
}
