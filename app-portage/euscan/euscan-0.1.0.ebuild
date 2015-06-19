# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/euscan/euscan-0.1.0.ebuild,v 1.4 2014/07/06 12:34:51 mgorny Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] 3.* 2.7-pypy-*"
PYTHON_USE_WITH="xml"
PYTHON_NONVERSIONED_EXECUTABLES=(".*")

inherit distutils python

DESCRIPTION="Ebuild upstream scan utility"
HOMEPAGE="http://euscan.iksaif.net"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND="sys-apps/portage"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.2.8
	dev-python/setuptools
	dev-python/beautifulsoup:python-2"

distutils_src_compile_pre_hook() {
	echo VERSION="${PV}" "$(PYTHON)" setup.py set_version
	VERSION="${PV}" "$(PYTHON)" setup.py set_version
}

src_compile() {
	distutils_src_compile
}
