# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

GIT_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/rafaelmartins/blohg.git
		https://github.com/rafaelmartins/blohg"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="A Mercurial (or Git) based blogging engine"
HOMEPAGE="http://blohg.org/ https://pypi.python.org/pypi/blohg"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc git +mercurial test"

REQUIRED_USE="|| ( git mercurial )
	test? ( git mercurial )"

RDEPEND="
	>=dev-python/click-2.0
	=dev-python/docutils-0.11*
	>=dev-python/flask-0.10.1
	>=dev-python/flask-babel-0.7
	>=dev-python/frozen-flask-0.7
	>=dev-python/jinja-2.5.2
	dev-python/pyyaml
	dev-python/setuptools
	dev-python/pygments
	git? ( =dev-python/pygit2-0.20* )
	mercurial? ( >=dev-vcs/mercurial-1.6 )"

DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/mock )"

python_prepare_all() {
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

pkg_postinst() {
	local ver="${PV}"
	[[ ${PV} = *9999* ]] && ver="latest"

	elog "You may want to check the upgrade notes:"
	elog "http://docs.blohg.org/en/${ver}/upgrade/"
}
