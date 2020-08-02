# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

GIT_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/rafaelmartins/blohg"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="A Mercurial (or Git) based blogging engine"
HOMEPAGE="https://github.com/rafaelmartins/blohg"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~rafaelmartins/distfiles/${PN}-patches-${PVR}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc git +mercurial test"
RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( git mercurial )
	test? ( git mercurial )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/feedgenerator[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-babel[${PYTHON_USEDEP}]
	dev-python/frozen-flask[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	git? ( dev-python/pygit2[${PYTHON_USEDEP}] )
	mercurial? ( >=dev-vcs/mercurial-5.2[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

python_prepare_all() {
	if [[ ${PV} != *9999* ]]; then
		eapply "${WORKDIR}/${PN}-patches-${PVR}"
	fi

	if ! use git; then
		rm -rf blohg/vcs_backends/git || die 'rm failed'
	fi

	if ! use mercurial; then
		rm -rf blohg/vcs_backends/hg || die 'rm failed'
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

python_test() {
	esetup.py test
}
