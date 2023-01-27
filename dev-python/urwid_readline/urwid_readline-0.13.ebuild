# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Text input widget for urwid that supports readline shortcuts"
HOMEPAGE="
	https://github.com/rr-/urwid_readline/
	https://pypi.org/project/urwid-readline/"
SRC_URI="
	https://github.com/rr-/urwid_readline/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="dev-python/urwid[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
