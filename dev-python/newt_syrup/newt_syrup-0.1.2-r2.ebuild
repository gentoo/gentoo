# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python framework for creating text-based applications"
HOMEPAGE="https://pagure.io/newt"
SRC_URI="https://mcpierce.fedorapeople.org/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-libs/newt-0.52.11"

DOCS=( AUTHORS ChangeLog COLORS )
