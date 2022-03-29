# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit llvm meson xdg

DESCRIPTION="An EFL-based IDE"
HOMEPAGE="https://www.enlightenment.org/about-edi
	https://phab.enlightenment.org/w/projects/edi/
	https://github.com/Enlightenment/edi"
SRC_URI="https://github.com/Enlightenment/edi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3 LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="clang"

RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	>=dev-libs/efl-1.22.0[eet]
	clang? (
		dev-util/bear
		sys-devel/clang:=
	)"
DEPEND="${RDEPEND}
	dev-libs/check"
BDEPEND="virtual/libintl
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/edi-0.8.0-meson-0.61.1-fix.patch )

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_prepare() {
	default

	# fix a QA issue with .desktop file, https://phab.enlightenment.org/T7368
	sed -i '/Version=/d' data/desktop/edi.desktop* || die

	# fix 'unexpected path' QA warning
	sed -i 's|share/doc/edi/|share/doc/'${PF}'/|g' doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use clang bear)
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
