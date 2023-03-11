# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${PN}-${P}
DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="
	https://github.com/scott-griffiths/bitstring/
	https://pypi.org/project/bitstring/
"
SRC_URI="
	https://github.com/scott-griffiths/${PN}/archive/${P}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

distutils_enable_tests unittest

src_prepare() {
	[[ ${PV} != 4.0.1 ]] && die "Remove the hack!"
	cat >> pyproject.toml <<-EOF

		[build-system]
		build-backend = "setuptools.build_meta"
	EOF
	distutils-r1_src_prepare
}

src_test() {
	cd tests || die
	distutils-r1_src_test
}
