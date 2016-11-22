# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 mercurial

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories"
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion/wiki/Home https://pypi.python.org/pypi/hgsubversion"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/durin42/hgsubversion"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-vcs/mercurial[${PYTHON_USEDEP}]
	|| (
		dev-python/subvertpy[${PYTHON_USEDEP}]
		>=dev-vcs/subversion-1.5[${PYTHON_USEDEP}]
	)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/nose[${PYTHON_USEDEP}] )"

DOCS=( README )
