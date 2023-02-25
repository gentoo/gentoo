# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

COMMIT="4cd030ad37bedff37345b37c1f1cd118530429ed"

DESCRIPTION="Additional lexers for use in Pygments"
HOMEPAGE="https://github.com/facelessuser/pymdown-lexers"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	>=dev-python/pygments-2.0.1[${PYTHON_USEDEP}]
"
