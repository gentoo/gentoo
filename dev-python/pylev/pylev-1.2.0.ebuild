# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python Levenshtein implementation"
HOMEPAGE="https://github.com/toastdriven/pylev"
SRC_URI="https://github.com/toastdriven/pylev/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
