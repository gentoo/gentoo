# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Simple python replacement for the MaxMind geoipupdate program"
HOMEPAGE="https://michael.orlitzky.com/code/geoipyupdate.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

DOCS=( README.rst doc/geoipyupdate-sample.toml )

src_install() {
	distutils-r1_src_install
	doman doc/man1/geoipyupdate.1
}
