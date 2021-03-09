# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit meson multilib-minimal python-any-r1

DESCRIPTION="Handler library for evdev events"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libevdev/ https://gitlab.freedesktop.org/libevdev/libevdev"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libevdev/libevdev.git"
	inherit git-r3
else
	SRC_URI="https://www.freedesktop.org/software/libevdev/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc test"

DEPEND="test? ( dev-libs/check[${MULTILIB_USEDEP}] )"
BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
RESTRICT="!test? ( test )"

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature doc documentation)
		$(meson_feature test tests)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson test -v -C "${BUILD_DIR}" -t 100 || die "tests failed"
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	if use doc; then
		local HTML_DOCS=( doc/html/. )
		einstalldocs
	fi
}
