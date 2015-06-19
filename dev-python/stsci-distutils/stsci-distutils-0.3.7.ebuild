# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/stsci-distutils/stsci-distutils-0.3.7.ebuild,v 1.6 2015/03/09 00:00:05 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Utilities used to package some of STScI's Python projects"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/stsci_python"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/d2to1[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
