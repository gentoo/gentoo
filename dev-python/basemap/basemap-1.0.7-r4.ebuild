# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="matplotlib toolkit to plot map projections"
HOMEPAGE="https://matplotlib.org/basemap/ https://pypi.org/project/basemap/"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

IUSE="examples test"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT GPL-2"

DEPEND="sci-libs/shapelib
	$(python_gen_cond_dep '
		|| (
			>=dev-python/matplotlib-python2-0.98[${PYTHON_MULTI_USEDEP}]
			>=dev-python/matplotlib-0.98[${PYTHON_MULTI_USEDEP}]
		)
	')
	>=sci-libs/geos-3.3.1[python(-),${PYTHON_SINGLE_USEDEP}]"

RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/pupynere-1.0.8[${PYTHON_MULTI_USEDEP}]
		dev-python/httplib2[${PYTHON_MULTI_USEDEP}]
		dev-python/dap[${PYTHON_MULTI_USEDEP}]
	')"

DOCS="FAQ API_CHANGES"
#REQUIRED_USE="test? ( examples )"
# The test phase ought never have been onvoked according to the above.
# The test phase appears to require the package to fist be emerged, which ...
# Until the distutils_install_for_testing func refrains from failing with
# mkdir: cannot create directory ‘/test’: Permission denied
# reluctantly this phase is assigned
RESTRICT="test"

src_prepare() {
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		setup.py || die
	# use /usr/share/data
	sed -i \
		-e "/_datadir.*=.*join/s|\(.*datadir.*=\).*|\1'${EROOT}usr/share/${PN}'|g" \
		"${S}"/lib/mpl_toolkits/basemap/*.py || die
	distutils-r1_src_prepare
	append-flags -fno-strict-aliasing
}

#src_test() {
#	distutils_install_for_testing
#}

python_install() {
	# mpl_toolkits namespace provided by dev-python/matplotlib
	rm "${BUILD_DIR}/lib/mpl_toolkits/__init__.py" || die
	distutils-r1_python_install --skip-build
	#  --install-data="${EPREFIX}/usr/share/${PN}" on testing is found not to work;
	# setup.py is a mess. Someone care to patch setup.py please proceed; substitute with
	insinto /usr/share/basemap/
	doins  lib/mpl_toolkits/basemap/data/*

	# respect FHS
	rm -r "${D}$(python_get_sitedir)/mpl_toolkits/basemap/data" || die
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
