# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Browser-based user interface for BorgBackup"
HOMEPAGE="https://pypi.org/project/borgweb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-backup/borgbackup[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]"
