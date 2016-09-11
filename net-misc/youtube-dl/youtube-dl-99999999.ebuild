# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5})
DISTUTILS_SINGLE_IMPL=true
inherit bash-completion-r1 distutils-r1 eutils git-r3

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://rg3.github.com/youtube-dl/"
EGIT_REPO_URI="https://github.com/rg3/youtube-dl.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( dev-python/nose[coverage(+)] )
"

src_compile() {
	distutils-r1_src_compile
	emake -C docs man
	${PYTHON} devscripts/bash-completion.py
}

src_test() {
	emake test
}

src_install() {
	python_domodule youtube_dl
	dobin bin/${PN}
	dodoc README.md
	doman docs/_build/man/${PN}.1
	newbashcomp ${PN}.bash-completion ${PN}
	python_fix_shebang "${ED}"
}
