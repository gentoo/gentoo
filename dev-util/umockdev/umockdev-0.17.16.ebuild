# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit meson-multilib python-any-r1 vala

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/martinpitt/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/martinpitt/umockdev/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Mock hardware devices for creating unit tests"
HOMEPAGE="https://github.com/martinpitt/umockdev/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/libpcap[${MULTILIB_USEDEP}]
	virtual/libudev:=[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=dev-libs/gobject-introspection-1.32:=
"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		dev-libs/libgudev:=[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	$(vala_depend)
	app-arch/xz-utils
	virtual/pkgconfig
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_setup
}

multilib_src_configure() {
	export VALAC="$(type -P valac-$(vala_best_api_version))"
	meson_src_configure
}

multilib_src_test() {
	meson_src_test --no-suite fails-valgrind
}
