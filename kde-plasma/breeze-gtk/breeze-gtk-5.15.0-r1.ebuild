# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit kde5 python-r1

DESCRIPTION="Official GTK+ port of Plasma's Breeze widget style"
HOMEPAGE="https://cgit.kde.org/breeze-gtk.git"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}
	$(add_plasma_dep breeze)
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-lang/sassc
"

pkg_setup() {
	python_setup
	kde5_pkg_setup
}
