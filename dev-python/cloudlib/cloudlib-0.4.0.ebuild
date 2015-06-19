# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cloudlib/cloudlib-0.4.0.ebuild,v 1.2 2015/05/09 22:26:55 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Cloud middleware for in application use."
HOMEPAGE="https://github.com/cloudnull/cloudlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/prettytable-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]"

python_prepare() {
	sed -i "s/required.append\(\'argparse\'\)/pass/g" setup.py || die
}
