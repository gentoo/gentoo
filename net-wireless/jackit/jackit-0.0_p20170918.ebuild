# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )
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

DEPEND=""
RDEPEND="${DEPEND}
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyusb[${PYTHON_USEDEP}]"
