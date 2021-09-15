# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="
	https://sendapatch.se/projects/pylibmc/
	https://pypi.org/project/pylibmc/
	https://github.com/lericson/pylibmc/"
# One image is missing from the doc at PyPI
# https://github.com/lericson/pylibmc/pull/221
SRC_URI="https://github.com/lericson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ~ppc64 x86"

RDEPEND=">=dev-libs/libmemcached-0.32"
# Older sphinx versions fail to compile the doc
# https://github.com/sphinx-doc/sphinx/issues/3266
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		net-misc/memcached
	)"

PATCHES=(
	"${FILESDIR}/pylibmc-1.6.1-fix-test-failures-r1.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests --install nose

python_prepare_all() {
	sed -e "/with-info=1/d" -i setup.cfg || die

	# some amazon thing, expects to be in AWS
	rm tests/test_autoconf.py || die
	distutils-r1_python_prepare_all

	# needed for docs
	export PYLIBMC_DIR=.
}

src_test() {
	local -x MEMCACHED_PORT=11219
	memcached -d -p "${MEMCACHED_PORT}" -u nobody -l localhost \
		-P "${T}/m.pid" || die
	distutils-r1_src_test
	kill "$(<"${T}/m.pid")" || die
}
