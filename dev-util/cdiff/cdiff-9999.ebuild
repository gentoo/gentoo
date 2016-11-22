# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 git-r3

DESCRIPTION="Term based view of colored, incremental diff in a Git/Mercurial/Svn workspace"
HOMEPAGE="https://github.com/ymattw/${PN}"
EGIT_REPO_URI="https://github.com/ymattw/cdiff.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	!<app-misc/colordiff-1.0.13-r1
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-apps/less"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.9.2-disable-unimportant-failing-test.patch )

DOCS=( CHANGES.rst README.rst )

python_test() {
	${PYTHON} tests/test_cdiff.py || die "Unit tests failed."

	./tests/regression.sh || die "Regression tests failed."
}
