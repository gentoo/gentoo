# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="TurboJson"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="TurboGears JSON file format support plugin"
HOMEPAGE="https://pypi.org/project/TurboJson/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-python/simplejson-1.9.1[${PYTHON_USEDEP}]
	>=dev-python/peak-rules-0.5[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
# Testsuite requires a package of peak not present in portage
