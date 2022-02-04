# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Python Levenshtein implementation"
HOMEPAGE="https://github.com/toastdriven/pylev"
SRC_URI="https://github.com/toastdriven/pylev/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

distutils_enable_tests unittest
