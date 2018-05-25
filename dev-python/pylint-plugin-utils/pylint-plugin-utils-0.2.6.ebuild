# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Utilities and helpers for writing Pylint plugins"
HOMEPAGE="https://github.com/PyCQA/pylint-plugin-utils"
SRC_URI="https://pypi.python.org/packages/39/bf/7812ea0df88d60795ef777303beb7e4b1da8e4b465c87ee7a0c5eaa6c350/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
