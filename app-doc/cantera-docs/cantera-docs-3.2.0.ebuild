# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Documentation API reference for Cantera package libraries"
HOMEPAGE="https://cantera.org"
# Non-modified pre-build online documentation is available on https://cantera.org
# or on api-docs repository https://github.com/Cantera/api-docs/tree/main/3.2
SRC_URI="https://github.com/band-a-prend/gentoo-overlay/releases/download/ct-docs-${PV}/${P}.tar.xz"

S="${WORKDIR}/"

## MIT license is for doxygen-awesome-css
## Apache-2.0 license is for MathJax (for offline equations rendering)
LICENSE="BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

src_install() {
	insinto /usr/share/
	doins -r "${S}/."
}
