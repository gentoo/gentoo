# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

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
	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(
		--resourcepath=/usr/share
		--no-compress-manpages
	)
}

python_test_all() {
	# GRAMPS builds just fine out of tree but it confuses its test suite.
	# The following might be an ugly hack but at least it lets the tests
	# run properly until either I or upstream have come up with something
	# better.
	rm -rf "${S}/build" && ln -s "${BUILD_DIR}" "${S}"/build || \
		die "Failed to symlink build directory to source directory"

	esetup.py test
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
