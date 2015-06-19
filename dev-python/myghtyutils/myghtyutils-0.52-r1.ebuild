# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/myghtyutils/myghtyutils-0.52-r1.ebuild,v 1.1 2014/12/31 04:36:53 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="MyghtyUtils"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Set of utility classes used by Myghty templating"
HOMEPAGE="http://www.myghty.org http://pypi.python.org/pypi/MyghtyUtils"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/myghty[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
