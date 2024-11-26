# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.5.0
PVCUT=$(ver_cut 1-3)
PYTHON_COMPAT=( python3_{10..13} )
inherit ecm plasma.kde.org python-any-r1

DESCRIPTION="Official GTK+ port of Plasma's Breeze widget style"
HOMEPAGE="https://invent.kde.org/plasma/breeze-gtk"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

BDEPEND="${PYTHON_DEPS}
	dev-lang/sassc
	$(python_gen_any_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	>=kde-plasma/breeze-${PVCUT}:6
"

python_check_deps() {
	python_has_version "dev-python/pycairo[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	ecm_pkg_setup
}
