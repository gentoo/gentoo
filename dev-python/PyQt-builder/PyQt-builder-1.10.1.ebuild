# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="The PEP 517 compliant PyQt build system"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt-builder/ https://pypi.org/project/PyQt-builder/ https://www.riverbankcomputing.com/static/Docs/PyQt-builder/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
RDEPEND="dev-python/sip[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install
}
