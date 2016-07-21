# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories"
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion/wiki/Home https://pypi.python.org/pypi/hgsubversion"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-vcs/mercurial-1.4
	|| (
		dev-python/subvertpy
		>=dev-vcs/subversion-1.5[python]
	)
"
DEPEND="
	dev-python/setuptools
	test? ( dev-python/nose )
"

DOCS="README"

src_test() {
	cd tests

	testing() {
		PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" run.py
	}
	python_execute_function testing
}
