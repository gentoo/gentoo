# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="The new generation of the pytest-salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt-factories"
SRC_URI="https://github.com/saltstack/${PN}/archive/${PV//_/}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${PN}-${PV//_/}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="test"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/pytest-tempdir[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
	dev-python/pytest-system-statistics[${PYTHON_USEDEP}]
	>=dev-python/pytest-shell-utilities-1.4.0[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=app-admin/salt-3001.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/pytest-salt-factories-1.0.0_rc20-tests.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -e "s:use_scm_version=True:version='${PV}', name='${PN//-/.}':" -i setup.py || die
	sed -r -e '/(setuptools|setup_requires)/ d' -i setup.cfg || die

	sed -i 's:tool.setuptools_scm:tool.disabled:' pyproject.toml || die
	printf '__version__ = "%s"\n' "${PV}" > src/saltfactories/version.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local tempdir

	local -a disable_tests=(
		testexcludetest
	)
	local textexpr
	testexpr=$(printf 'not %s and ' "${disable_tests[@]}")

	# ${T} is too long a path for the tests to work
	tempdir="$(mktemp -du --tmpdir=/tmp salt-XXX)" || die
	addwrite "${tempdir}"

	(
		cleanup() { rm -rf "${tempdir}" || die; }

		trap cleanup EXIT
		export SHELL="/bin/bash" TMPDIR="${tempdir}"
		epytest -vv -k "${testexpr%and }"
	)
}
