# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Helper module for logging to Robot Framework log from background threads"
HOMEPAGE="https://github.com/robotframework/robotbackgroundlogger https://pypi.org/project/robotbackgroundlogger/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/robotframework[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
