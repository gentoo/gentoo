# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://sendapatch.se/projects/pylibmc/ https://pypi.org/project/pylibmc/"
# One image is missing from the doc at PyPI
# https://github.com/lericson/pylibmc/pull/221
SRC_URI="https://github.com/lericson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# implementations to use for building docs, separate from PYTHON_COMPAT since
# dev-python/sphinx might not be available everywhere
DOCS_PYTHON_COMPAT=( python{2_7,3_{6,7}} )

RDEPEND=">=dev-libs/libmemcached-0.32"
# Older sphinx versions fail to compile the doc
# https://github.com/sphinx-doc/sphinx/issues/3266
BDEPEND="${RDEPEND}
	doc? ( $(python_gen_cond_dep '
		>=dev-python/sphinx-1.5.1-r1[${PYTHON_USEDEP}]' "${DOCS_PYTHON_COMPAT[@]}")
	)
	test? (
		net-misc/memcached
		dev-python/nose[${PYTHON_USEDEP}]
	)"

RESTRICT="!test? ( test )"

REQUIRED_USE="doc? ( || ( $(python_gen_useflags "${DOCS_PYTHON_COMPAT[@]}") ) )"

PATCHES=(
	"${FILESDIR}/pylibmc-1.6.1-fix-test-failures-r1.patch"
)

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( "${DOCS_PYTHON_COMPAT[@]}" )
}

python_prepare_all() {
	sed -e "/with-info=1/d" -i setup.cfg || die

	# some amazon thing, expects to be in AWS
	rm tests/test_autoconf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# This variable is added to sys.path
		# but it does not seem to be useful
		PYLIBMC_DIR="." emake -C docs
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	memcached -d -p 11219 -u nobody -l localhost -P "${T}/m.pid" || die
	MEMCACHED_PORT=11219 nosetests -v
	local ret=${?}
	kill "$(<"${T}/m.pid")" || die
	[[ ${ret} == 0 ]] || die "Tests fail with ${EPYTHON}!"
}
