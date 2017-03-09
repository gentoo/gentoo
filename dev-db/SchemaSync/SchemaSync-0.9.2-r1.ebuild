# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="MySQL Schema Versioning and Migration Utility"
HOMEPAGE="https://github.com/mmatuson/SchemaSync"
# old download location is down
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/mysql-python[${PYTHON_USEDEP}]
	dev-python/SchemaObject[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
