# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Pure Python read/write support for ESRI Shapefile format"
HOMEPAGE="https://pypi.org/project/pyshp/"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	ESVN_REPO_URI="https://${PN}.googlecode.com/svn/trunk"
	inherit subversion
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
