# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Naming Convention checker for Python"
HOMEPAGE="https://pypi.python.org/pypi/pep8-naming"
SRC_URI="https://github.com/PyCQA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/flake8-polyfill-1.0.2
	<dev-python/flake8-polyfill-2.0.0
"
DEPEND="${RDEPEND}"
