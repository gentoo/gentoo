# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Setuptools/distribute plugin for finding files under Mercurial version control"
HOMEPAGE="https://pypi.python.org/pypi/setuptools_hg https://bitbucket.org/jezdez/setuptools_hg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="dev-vcs/mercurial"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
