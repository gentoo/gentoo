# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}-community"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Lightweight SOAP client (community fork) (active development)"
HOMEPAGE="https://github.com/suds-community/suds"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

DOCS=( README.md notes/. )

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

src_prepare() {
	default
	sed -i \
		-e 's/package_name = "suds-community/package_name = "suds/' \
		-e 's/extra_setup_params\["obsoletes"\]/pass  #/' \
		setup.py || die
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
