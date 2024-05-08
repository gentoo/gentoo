# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Yet Another SWF Parser"
HOMEPAGE="https://github.com/facundobatista/yaswfp"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
