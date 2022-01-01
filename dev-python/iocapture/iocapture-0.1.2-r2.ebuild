# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Capture stdout, stderr easily"
HOMEPAGE="https://pypi.org/project/iocapture/"
SRC_URI="https://github.com/oinume/iocapture/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ~sparc x86"
LICENSE="MIT"

BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
