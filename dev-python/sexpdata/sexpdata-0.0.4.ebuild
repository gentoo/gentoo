# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="a simple S-expression parser/serializer"
HOMEPAGE="
	https://github.com/jd-boyd/sexpdata/
	https://pypi.org/project/sexpdata/
"
SRC_URI="
	https://github.com/jd-boyd/sexpdata/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:install_requires\.append.*:pass:' setup.py || die
	distutils-r1_src_prepare
}
