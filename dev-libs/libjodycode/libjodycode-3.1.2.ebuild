# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shared code used by several utilities written by Jody Bruchon"
HOMEPAGE="https://codeberg.org/jbruchon/libjodycode"
SRC_URI="https://codeberg.org/jbruchon/libjodycode/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

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
