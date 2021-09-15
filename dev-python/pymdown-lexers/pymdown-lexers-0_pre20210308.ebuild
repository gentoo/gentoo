# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

COMMIT="84dc78c7692720bd614209124c3e8af65678532a"

DESCRIPTION="Additional lexers for use in Pygments"
HOMEPAGE="https://github.com/facelessuser/pymdown-lexers"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/pygments-2.0.1[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${COMMIT}"
