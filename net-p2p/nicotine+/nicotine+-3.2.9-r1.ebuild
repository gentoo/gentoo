# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="gdbm"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg

DESCRIPTION="Graphical client for the Soulseek peer to peer network written in Python"
HOMEPAGE="https://nicotine-plus.org/"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nicotine-plus-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND="sys-devel/gettext"
RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${RDEPEND}"

EPYTEST_IGNORE=(
	"test/integration/test_startup.py"
)

distutils_enable_tests pytest
