# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A collection of functions, classes and so on, for vdr plugins"
HOMEPAGE="https://github.com/wirbel-at-vdr-portal/librepfunc"
SRC_URI="https://github.com/wirbel-at-vdr-portal/librepfunc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/makefile-lib.patch"
)

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" libsubdir="$(get_libdir)" package_name="${PF}" install
	einstalldocs
}
