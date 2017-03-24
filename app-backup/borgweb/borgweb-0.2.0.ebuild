# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Browser-based user interface for BorgBackup"
HOMEPAGE="https://pypi.python.org/pypi/borgweb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPENDS="dev-python/setuptools"
RDEPENDS="app-backup/borgbackup"
