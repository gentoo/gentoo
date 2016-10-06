# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/aspiers/git-deps"
EGIT_BRANCH=master

PYTHON_COMPAT=( python2_7 )

inherit eutils git-r3 python-single-r1

DESCRIPTION="git commit dependency analysis tool"
HOMEPAGE="https://github.com/aspiers/git-deps"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pygit2[${PYTHON_USEDEP}]
	net-libs/nodejs
	${PYTHON_DEPS}
	"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

HTML_DOCS="html/."

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	python_newscript git-deps.py git-deps
	einstalldocs
}

pkg_postinst() {
	elog "Notes regarding the '--serve' option:"
	elog "Please run 'npm install browserify' once"
	elog "Copy the html sources:"
	elog "rsync -av ${EROOT}/usr/share/${PN}/html ~/git-deps-html"
	elog "cd ~/git-deps-html"
	elog "npm install"
	elog "browserify -t coffeeify -d js/git-deps-graph.coffee -o js/bundle.js"
}
