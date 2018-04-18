# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="attempts to find and list the requirements of a Python project"
HOMEPAGE="https://github.com/landscapeio/requirements-detector"
SRC_URI="https://github.com/landscapeio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/astroid-1.4.0
"
RDEPEND="${DEPEND}"
