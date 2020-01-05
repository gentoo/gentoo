# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="A decorator which enforces only some args may be passed positionally."
HOMEPAGE="https://github.com/morganfainberg/positional"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
