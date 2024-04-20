# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Decorator for retrying when exceptions occur"
HOMEPAGE="https://github.com/pnpnpn/retry-decorator"
SRC_URI="https://github.com/pnpnpn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86"

DOCS=( README.rst )

distutils_enable_tests pytest
