# Copyright 2001-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 xdg-utils

DESCRIPTION="Community genealogy program aiming to be both intuitive and feature-complete"
HOMEPAGE="https://gramps-project.org/"
SRC_URI="
	https://github.com/gramps-project/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif geo postscript +rcs +reports spell test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.12:3[cairo,${PYTHON_USEDEP}]
		dev-python/pyicu[${PYTHON_USEDEP}]
		exif? ( >=media-libs/gexiv2-0.5[${PYTHON_USEDEP},introspection] )
	')
	gnome-base/librsvg:2
	>x11-libs/gtk+-3.14.8:3[introspection]
	x11-libs/pango[introspection]
	x11-misc/xdg-utils
	dev-python/orjson
	geo? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	spell? ( app-text/gtkspell:3[introspection] )
	rcs? ( dev-vcs/rcs )
	reports? ( media-gfx/graphviz[postscript?] )
"
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	')
)"

DISTUTILS_ARGS=(
	--no-compress-manpages
)

distutils_enable_tests unittest

src_prepare() {
	# Install documentation to the proper location. This can't be done
	# easily with a patch because we substitute in the ${PF} variable,
	# and that changes with every revision.
	sed -i -e "s:share/doc/gramps:share/doc/${PF}:g" setup.py || die

	default
}

python_test() {
	# gramps.gen.utils.test.file_test.FileTest.test_mediapath expects existing ~/.gramps
	# see https://gramps-project.org/bugs/view.php?id=13305
	mkdir -p "${HOME}/.gramps" || die
	# we need to populate test data to resources, they are not installed
	ln -snf "${S}/data/tests" "${BUILD_DIR}/install/usr/share/gramps/tests" || die
	# test_imp_sample_ged wrongly detects mimetype for OBJE without file in ${S}
	rm -f data/tests/imp_sample.ged || die

	# TZ=UTC is expected in ged export test, #939161
	local -x GRAMPS_RESOURCES="${BUILD_DIR}/install/usr/share" GDK_BACKEND=- TZ=UTC
	eunittest -p "*_test.py"

	# we don't want to install this symlink
	rm -f "${BUILD_DIR}/install/usr/share/gramps/tests" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
