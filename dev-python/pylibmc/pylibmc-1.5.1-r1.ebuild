# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://sendapatch.se/projects/pylibmc/ https://pypi.org/project/pylibmc/"
# One image is missing from the doc at PyPI
# https://github.com/lericson/pylibmc/pull/221
SRC_URI="https://github.com/lericson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/libmemcached-0.32"
# Older sphinx versions fail to compile the doc
# https://github.com/sphinx-doc/sphinx/issues/3266
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.5.1-r1[${PYTHON_USEDEP}] )
	test? (
		net-misc/memcached
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -e "/with-info=1/d" -i setup.cfg || die
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
	memcached -d -p 11219 -u nobody -l localhost -P "${T}/m.pid" || die
	MEMCACHED_PORT=11219 nosetests
	local ret=${?}
	kill "$(<"${T}/m.pid")" || die
	[[ ${ret} == 0 ]] || die "Tests fail with ${EPYTHON}!"
}
