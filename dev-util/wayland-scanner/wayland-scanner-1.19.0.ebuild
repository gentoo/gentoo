# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	inherit git-r3
else
	SRC_URI="https://wayland.freedesktop.org/releases/wayland-${PV}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	S="${WORKDIR}/wayland-${PV}"
fi
inherit meson multilib-minimal

DESCRIPTION="wayland-scanner tool"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT"
SLOT="0"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	!<dev-libs/wayland-${PV}
	>=dev-libs/expat-2.1.0-r3:=[$MULTILIB_USEDEP]
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		-Ddocumentation=false
		-Ddtd_validation=false
		-Dlibraries=false
		-Dscanner=true
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
