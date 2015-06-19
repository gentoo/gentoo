# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hgsubversion/hgsubversion-9999.ebuild,v 1.2 2014/08/10 21:23:18 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils mercurial

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories"
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion/wiki/Home http://pypi.python.org/pypi/hgsubversion"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/durin42/hgsubversion"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
