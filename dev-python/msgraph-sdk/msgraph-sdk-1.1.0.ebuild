# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Microsoft Graph SDK for Python"
HOMEPAGE="
	https://pypi.org/project/msgraph-sdk/
	https://github.com/microsoftgraph/msgraph-sdk-python/
"
SRC_URI="
	https://github.com/microsoftgraph/msgraph-sdk-python/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	$(pypi_wheel_url --unpack)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	app-arch/unzip
"

distutils_enable_tests unittest

src_unpack() {
	default
	mv msgraph-sdk-python-${PV} msgraph_sdk-${PV}
}

python_compile() {
	python_domodule msgraph "${WORKDIR}"/*.dist-info
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
