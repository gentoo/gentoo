# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A Pattern-Matching Language Based on OMeta and Python"
HOMEPAGE="https://github.com/python-parsley/parsley"
SRC_URI="https://github.com/python-${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
