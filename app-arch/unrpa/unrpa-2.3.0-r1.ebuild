# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Ren'Py's RPA data file extractor"
HOMEPAGE="https://github.com/Lattyware/unrpa"
SRC_URI="https://github.com/Lattyware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
