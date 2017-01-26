# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/hickford/MechanicalSoup"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
	KEYWORDS="~amd64"
fi

DESCRIPTION="a python library for automating interaction with web sites"
HOMEPAGE="https://pypi.python.org/pypi/MechanicalSoup"

LICENSE="MIT"
SLOT="0"
IUSE=""

COMMON_DEPEND="
	>=dev-python/beautifulsoup-4.0
	>=dev-python/requests-2.0
	>=dev-python/six-1.4
"
DEPEND="
${COMMON_DEPEND}
app-arch/unzip
	dev-python/setuptools
"
RDEPEND="${COMMON_DEPEND}"
