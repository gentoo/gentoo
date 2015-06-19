# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/euscan/euscan-0.1.1-r1.ebuild,v 1.4 2015/04/08 07:30:33 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="Ebuild upstream scan utility"
HOMEPAGE="http://euscan.iksaif.net"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.2.8[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]"

python_prepare_all() {
	python_export_best
	echo VERSION="${PV}" "${PYTHON}" setup.py set_version
	VERSION="${PV}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all
}
