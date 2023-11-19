# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit git-r3 distutils-r1

EGIT_REPO_URI="https://github.com/georgewhewell/undervolt.git"
DESCRIPTION="Undervolt Intel CPUs under Linux"
HOMEPAGE="https://github.com/georgewhewell/undervolt"

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
