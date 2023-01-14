# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

MY_P=${PN/-/_}-${PV}
DESCRIPTION="distutils extension to work with PyQt applications and UI files"
HOMEPAGE="https://github.com/ColinDuquesnoy/pyqt_distutils"
SRC_URI="https://github.com/ColinDuquesnoy/pyqt_distutils/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
