# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 xdg-utils

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="https://gramps-project.org/"
SRC_URI="https://github.com/gramps-project/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rcs +reports exif geo postscript spell"

RDEPEND="
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.12:3[cairo,${PYTHON_USEDEP}]
	dev-python/pyicu[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	>x11-libs/gtk+-3.14.8:3[introspection]
	x11-libs/pango[introspection]
	x11-misc/xdg-utils
	reports? ( media-gfx/graphviz[postscript?] )
	exif? ( >=media-libs/gexiv2-0.5[${PYTHON_USEDEP},introspection] )
	geo? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	spell? ( app-text/gtkspell:3[introspection] )
	rcs? ( dev-vcs/rcs )
"

python_prepare_all() {
	# Install documentation to the proper location. This can't be done
	# easily with a patch because we substitute in the $PF variable,
	# and that changes with every revision.
	sed -i "s:share/doc/gramps:share/doc/${PF}:g" setup.py || die
	eapply "${FILESDIR}/${P}-uncompressed-docs.patch"
	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=( --resourcepath=/usr/share )
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
