# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit kde5 python-any-r1

DESCRIPTION="Official GTK+ port of Plasma's Breeze widget style"
HOMEPAGE="https://cgit.kde.org/breeze-gtk.git"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="${PYTHON_DEPS}
	$(add_plasma_dep breeze)
	$(python_gen_any_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	dev-lang/sassc
"

python_check_deps() {
	has_version "dev-python/pycairo[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	kde5_pkg_setup
}
