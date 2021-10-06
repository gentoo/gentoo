# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sends virtual input commands"
HOMEPAGE="https://github.com/moses-palmer/pynput"

LICENSE="GPL-3"
SLOT="0"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/moses-palmer/pynput.git"
else
	SRC_URI="
		https://github.com/moses-palmer/pynput/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -e "s/ + SETUP_PACKAGES,/,/g" -i setup.py || die
	distutils-r1_src_prepare
}
