# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Pylint plugin for augmenting error detection in the standard Python library."
HOMEPAGE="https://github.com/landscapeio/pylint-common"
SRC_URI="https://pypi.python.org/packages/20/4d/603dc62edf8b303333c5df5ba47eeb2119ef2b87ef0d38356b3e48fa5739/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
