# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit bash-completion-r1 distutils-r1 vcs-snapshot

MY_PV=${PV/_/}

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cached-property-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
	>=dev-python/dockerpty-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/docker-py-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
	!~dev-python/PySocks-1.5.7[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.6.1[${PYTHON_USEDEP}]
	!~dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	!~dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/texttable-0.9[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]' 'python2_7' )
"
DEPEND="
	${CDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' 'python2_7' )
	)
"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.23.0-setup-py.patch
)

src_prepare() {
	# Address QA issue "docker-compose.exe: missing alias (symlink) for completed command."
	sed 's,^\(complete.*\) docker-compose\.exe\(.*\),\1\2,' -i contrib/completion/bash/docker-compose || die

	default
}

python_test() {
	${PYTHON} -m pytest tests/unit || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	newbashcomp contrib/completion/bash/docker-compose ${PN}

	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/*

	distutils-r1_python_install_all
}
