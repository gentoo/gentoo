# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 xdg-utils

DESCRIPTION="Community genealogy program aiming to be both intuitive and feature-complete"
HOMEPAGE="https://gramps-project.org/"
SRC_URI="https://github.com/gramps-project/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="berkdb exif geo postscript +rcs +reports spell test"

RESTRICT="!test? ( test )
	!berkdb? ( test )"

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
	berkdb? ( $(python_gen_cond_dep '
		dev-python/bsddb3[${PYTHON_USEDEP}]
	' python3_{8,9}) )
	geo? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	spell? ( app-text/gtkspell:3[introspection] )
	rcs? ( dev-vcs/rcs )
	reports? ( media-gfx/graphviz[postscript?] )
"
BDEPEND="test? ( ${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	')
)"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.3-test_locale.patch
)

python_prepare_all() {
	# Install documentation to the proper location. This can't be done
	# easily with a patch because we substitute in the ${PF} variable,
	# and that changes with every revision.
	sed -i "s:share/doc/gramps:share/doc/${PF}:g" setup.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	DISTUTILS_ARGS=(
		--resourcepath=/usr/share
		--no-compress-manpages
	)
}

python_test() {
	# Gramps builds just fine out of tree but it confuses its test suite.
	# The following might be an ugly hack but at least it lets the tests
	# run properly until either I or upstream have come up with something
	# better. FIXME: test this when a new release comes out.
	rm -rf "${S}/build" && ln -s "${BUILD_DIR}" "${S}"/build || \
		die "Failed to symlink build directory to source directory"

	# Set a sane default locale for the tests which do not explicitly set one.
	local -x LC_ALL=C.UTF-8

	esetup.py test || die
}

# Ugly hack to work around Bug #717922
python_install() {
	local DISTUTILS_ARGS=(
		--resourcepath=/usr/share
		--no-compress-manpages
		build
	)
	distutils-r1_python_install
	echo -n "${EPREFIX}/usr/share" > "${D}$(python_get_sitedir)/gramps/gen/utils/resource-path" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	if use berkdb; then
		ewarn "The BSDDB back-end in ${PN} has got known stability and data-corruption issues. It has been deprecated since version 5.1.0 and might be removed in 5.2.0."
		ewarn "If you have any family trees in this format you are highly advised to convert them to SQLite, as described here:"
		ewarn
		ewarn "https://gramps-project.org/wiki/index.php/Gramps_5.1_Wiki_Manual_-_Manage_Family_Trees#Converting_a_BSDDB_Family_Tree_to_SQLite"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
