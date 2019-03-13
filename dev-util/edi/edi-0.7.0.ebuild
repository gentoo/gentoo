# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit llvm meson xdg-utils

DESCRIPTION="An EFL-based IDE"
HOMEPAGE="https://www.enlightenment.org/about-edi"
SRC_URI="https://github.com/Enlightenment/edi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang"

RDEPEND="
	>=dev-libs/efl-1.21.1[eet,X]
	clang? ( sys-devel/clang:= )
"
DEPEND="
	${RDEPEND}
	dev-libs/check
"
BDEPEND="virtual/pkgconfig"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset

	# fix a QA issue with .desktop file, https://phab.enlightenment.org/T7368
	sed -i '/Version=/d' data/desktop/edi.desktop* || die

	# fix 'unexpected path' QA warning
	sed -i 's|share/doc/edi/|share/doc/'${PF}'/|g' doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		-D bear=false
		$(meson_use clang libclang)
	)

	if use clang; then
		emesonargs+=(
			-D libclang-headerdir="$(llvm-config --includedir)"
			-D libclang-libdir="$(llvm-config --libdir)"
		)
	fi

	meson_src_configure
}
