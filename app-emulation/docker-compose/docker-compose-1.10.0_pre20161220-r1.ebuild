# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit bash-completion-r1 distutils-r1 vcs-snapshot

GIT_COMMIT="09690e1758d39f1213a9f44ab027ad69e1de0653"

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://www.docker.com/"
SRC_URI="https://github.com/docker/compose/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cached-property-1.2.0[${PYTHON_USEDEP}]
	<dev-python/cached-property-2[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	<dev-python/colorama-0.4[${PYTHON_USEDEP}]
	>=dev-python/dockerpty-0.4.1[${PYTHON_USEDEP}]
	<dev-python/dockerpty-0.5[${PYTHON_USEDEP}]
	>=dev-python/docker-py-2.0.0[${PYTHON_USEDEP}]
	<dev-python/docker-py-3.0[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	<dev-python/docopt-0.7[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	<dev-python/pyyaml-4[${PYTHON_USEDEP}]
	!~dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	<dev-python/requests-2.12[${PYTHON_USEDEP}]
	>=dev-python/requests-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	<dev-python/six-2[${PYTHON_USEDEP}]
	>=dev-python/texttable-0.8.1[${PYTHON_USEDEP}]
	<dev-python/texttable-0.9[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	<dev-python/websocket-client-1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]' 'python2_7' )
	$(python_gen_cond_dep '<dev-python/enum34-2[${PYTHON_USEDEP}]' 'python2_7' )
"
DEPEND="
	${CDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' 'python2_7' )
	)
"
RDEPEND="${CDEPEND}"

python_test() {
	${PYTHON} -m pytest tests/unit || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	newbashcomp contrib/completion/bash/docker-compose ${PN}

	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/*

	distutils-r1_python_install_all
}
