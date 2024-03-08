# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

SRC_URI="https://github.com/georgewhewell/undervolt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Undervolt Intel CPUs under Linux"
HOMEPAGE="https://github.com/georgewhewell/undervolt"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
