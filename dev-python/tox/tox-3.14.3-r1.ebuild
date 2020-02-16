# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="https://tox.readthedocs.io https://github.com/tox-dev/tox https://pypi.org/project/tox/"
SRC_URI="https://github.com/tox-dev/tox/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 sparc x86"

# doc disabled because of missing deps in tree
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-1.1[${PYTHON_USEDEP}]
	' python3_{5,6,7} pypy3)
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/pluggy-1.0[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-16.0.0[${PYTHON_USEDEP}]"
# TODO: figure out how to make tests work without the package being
# installed first.
BDEPEND="
	test? (
		${RDEPEND}
		>=dev-python/flaky-3.4.0[${PYTHON_USEDEP}]
		<dev-python/flaky-4
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
		dev-python/pathlib2[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-2.0[${PYTHON_USEDEP}]
		=dev-python/tox-${PV}-${PR}[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-3.9.0-strip-setuptools_scm.patch"
)

src_prepare() {
	distutils-r1_src_prepare

	# broken without internet
	sed -i -e 's:test_provision_non_canonical_dep:_&:' \
		tests/unit/session/test_provision.py || die
	sed -i -e 's:test_provision_interrupt_child:_&:' \
		tests/integration/test_provision_int.py || die
	# broken with our mock version (?)
	sed -i -e 's:test_create_KeyboardInterrupt:_&:' \
		tests/unit/test_venv.py || die
	# broken with Gentoo Python layout
	sed -i -e 's:test_tox_get_python_executable:_&:' \
		-e 's:test_find_alias_on_path:_&:' \
		tests/unit/interpreters/test_interpreters.py || die
}

python_test() {
	distutils_install_for_testing
	pytest -vv --no-network || die "Testsuite failed under ${EPYTHON}"
}
