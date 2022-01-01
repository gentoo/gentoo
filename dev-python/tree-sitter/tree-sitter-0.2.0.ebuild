# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="https://github.com/tree-sitter/py-tree-sitter"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DISTUTILS_USE_SETUPTOOLS=bdepend

S="${WORKDIR}/${MY_P}"
