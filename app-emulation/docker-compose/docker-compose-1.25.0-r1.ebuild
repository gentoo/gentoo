# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cached-property-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/docker-py-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/dockerpty-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/texttable-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/backports-shutil_get_terminal_size-1.0.0[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/subprocess32-3.5.4[${PYTHON_USEDEP}]' 'python2_7' )"

DEPEND="${RDEPEND}
	test? ( <dev-python/pytest-4[${PYTHON_USEDEP}]
	<dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' 'python2_7' ) )"

S="${WORKDIR}/compose-${PV}"

PATCHES=(
	# Bug #679968 -- https://bugs.gentoo.org/679968
	# Bug #681002 -- https://bugs.gentoo.org/681002
	"${FILESDIR}"/${PN}-1.25.0-setup-py.patch
)

src_prepare() {
	# Address QA issue "docker-compose.exe: missing alias (symlink) for completed command."
	sed 's,^\(complete.*\) docker-compose\.exe\(.*\),\1\2,' -i contrib/completion/bash/docker-compose || die

	default
}

python_test() {
	distutils_install_for_testing
	${PYTHON} -m pytest tests/unit/ || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	newbashcomp contrib/completion/bash/docker-compose ${PN}

	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/*

	distutils-r1_python_install_all
}
