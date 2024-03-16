# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..11} )

inherit meson python-any-r1

DESCRIPTION="Convenient & cross-platform sandboxing C library"
HOMEPAGE="https://github.com/Snaipe/BoxFort"
SRC_URI="https://github.com/Snaipe/BoxFort/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/BoxFort-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="-alpha amd64 ~arm ~arm64 -hppa -ia64 -loong -m68k -mips -ppc -ppc64 -riscv -s390 -sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)"
BDEPEND="virtual/pkgconfig"

python_check_deps() {
	use test && has_version "dev-util/cram[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use test samples)
		$(meson_use test tests)
	)

	meson_src_configure
}
