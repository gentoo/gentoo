# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Colorful worry-free console applications for multiple platforms"
HOMEPAGE="https://pypi.org/project/colorclass/ https://github.com/Robpol86/colorclass"
SRC_URI="https://github.com/Robpol86/colorclass/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

PATCHES=(
	"${FILESDIR}/colorclass-2.2.0-tests.patch"
)

distutils_enable_tests pytest
