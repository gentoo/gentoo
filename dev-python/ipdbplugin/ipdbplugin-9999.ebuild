# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Nose plugin to use iPdb instead of Pdb when tests fail"
HOMEPAGE="https://pypi.python.org/pypi/ipdbplugin"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/flavioamieiro/nose-ipdb.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipdb
	dev-python/nose"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
