# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/aspiers/git-deps"
EGIT_BRANCH=master

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit git-r3 python-r1

DESCRIPTION="git commit dependency analysis tool"
HOMEPAGE="https://github.com/aspiers/git-deps"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-python/flask
	dev-python/pygit2
	net-libs/nodejs
	${PYTHON_DEPS}
	"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	python_foreach_impl python_newexe git-deps.py git-deps
}

pkg_postinst() {
	einfo "Please run 'npm install browserify' to use git-deps with the web UI."
}
