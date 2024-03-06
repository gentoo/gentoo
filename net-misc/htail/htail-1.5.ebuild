# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Tail over HTTP"
HOMEPAGE="https://github.com/vpelletier/htail"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
BDEPEND="${DISTUTILS_DEPS}"
