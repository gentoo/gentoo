# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nicotine-plus-${PV}"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${RDEPEND}"

EPYTEST_IGNORE=(
	"test/integration/test_startup.py"
)

distutils_enable_tests pytest
