# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MYPN=astroML_addons
MYP=${MYPN}-${PV}

DESCRIPTION="Performance add-ons for the astroML package"
HOMEPAGE="https://github.com/astroML/astroML_addons"
SRC_URI="mirror://pypi/${PN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/astroml[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MYP}"

DOCS=( README.rst )
