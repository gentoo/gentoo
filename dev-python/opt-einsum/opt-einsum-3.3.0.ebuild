# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

DESCRIPTION="Optimized Einsum: A tensor contraction order optimizer"
HOMEPAGE="https://pypi.org/project/opt-einsum/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S="${WORKDIR}/${P/-/_}"

BDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
