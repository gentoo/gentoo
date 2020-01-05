# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="Python bindings for the chmlib library"
HOMEPAGE="https://github.com/dottedmag/pychm"
SRC_URI="https://github.com/dottedmag/pychm/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-libs/chmlib"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
