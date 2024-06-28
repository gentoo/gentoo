# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shared code used by several utilities written by Jody Bruchon"
HOMEPAGE="https://github.com/jbruchon/libjodycode"
SRC_URI="https://github.com/jbruchon/libjodycode/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

# missing test script
# https://github.com/jbruchon/jdupes/issues/191
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.1-static-lib.patch
)

src_compile() {
	emake sharedlib
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIB_DIR="/usr/$(get_libdir)" \
		PREFIX="${EPREFIX}"/usr \
		install
	einstalldocs
}
