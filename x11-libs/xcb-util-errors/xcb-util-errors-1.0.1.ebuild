# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

XORG_TARBALL_SUFFIX="xz"
inherit python-any-r1 xorg-3

DESCRIPTION="Library that gives human readable names to XCB error, event, & request codes"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb-errors"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=">=x11-libs/libxcb-1.9.1:="
DEPEND="${RDEPEND}
	x11-base/xcb-proto"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'x11-base/xcb-proto[${PYTHON_USEDEP}]')
"

python_check_deps() {
	python_has_version "x11-base/xcb-proto[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	xorg-3_pkg_setup
}
