# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

COMMIT="fa422cb95b794157760259c5c20a1235e4a459be"

DESCRIPTION="Additional lexers for use in Pygments"
HOMEPAGE="https://github.com/facelessuser/pymdown-lexers"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/pygments-2.0.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
