# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="The new generation of the pytest-salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt-factories"
SRC_URI="https://github.com/saltstack/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-6.1.1[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/pytest-tempdir[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? ( >=app-admin/salt-3001.0[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/pytest-salt-factories-0.121.1-tests.patch"
)

distutils_enable_tests --install pytest

python_prepare_all() {
	sed -r -e "s:use_scm_version=True:version='${PV}', name='${PN//-/.}':" -i setup.py || die
	sed -r -e '/(setuptools|setup_requires)/ d' -i setup.cfg || die

	sed -i 's:[tool.setuptools_scm]:[tool.disabled]:' pyproject.toml || die
	printf '__version__ = "%s"\n' "${PV}" > saltfactories/version.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local tempdir

	# ${T} is too long a path for the tests to work
	tempdir="$(mktemp -du --tmpdir=/tmp salt-XXX)"
	mkdir "${T}/$(basename "${tempdir}")"

	addwrite "${tempdir}"
	ln -s "$(realpath --relative-to=/tmp "${T}/$(basename "${tempdir}")")" "${tempdir}" || die

	distutils_install_for_testing --via-root

	(
		cleanup() { rm -f "${tempdir}" || die; }

		trap cleanup EXIT
		SHELL="/bin/bash" TMPDIR="${tempdir}" \
			pytest -vv || die "Tests failed with ${EPYTHON}"
	)
}
