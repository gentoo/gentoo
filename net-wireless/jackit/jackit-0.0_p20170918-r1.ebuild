# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Exploit Code for Mousejack"
HOMEPAGE="https://github.com/insecurityofthings/jackit"
COMMIT="1c057fad102af7daad537421d95e2695caeff2b7"
SRC_URI="https://github.com/insecurityofthings/jackit/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND=""
RDEPEND="${DEPEND}
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyusb[${PYTHON_USEDEP}]"
