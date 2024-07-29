# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit bash-completion-r1 distutils-r1

MY_PV=${PV/_/-}
DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"

RDEPEND="
	>=dev-python/distro-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/docker-7[${PYTHON_USEDEP}]
	>=dev-python/dockerpty-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/texttable-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-5[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.2.2[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/compose-${MY_PV}"

EPYTEST_DESELECT=(
	# These are not ready for >=dev-python/docker-7
	tests/unit/cli/docker_client_test.py::TLSConfigTestCase::
)

distutils_enable_tests pytest

PATCHES=(
	# Bug #679968 -- https://bugs.gentoo.org/679968
	# Bug #681002 -- https://bugs.gentoo.org/681002
	"${FILESDIR}"/${PN}-1.29.0-setup-py.patch
	"${FILESDIR}"/${P}-tests-unit-cli-test-py.patch
	# Bug #920631 -- https://bugs.gentoo.org/920631
	"${FILESDIR}"/${P}-docker-7.patch
)

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	# Address QA issue "docker-compose.exe: missing alias (symlink) for completed command."
	sed 's,^\(complete.*\) docker-compose\.exe\(.*\),\1\2,' -i contrib/completion/bash/docker-compose || die

	default
}

python_test() {
	epytest tests/unit/
}

python_install_all() {
	newbashcomp contrib/completion/bash/docker-compose ${PN}

	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/*

	distutils-r1_python_install_all
}
