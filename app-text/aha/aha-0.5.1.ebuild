# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Converts ANSI escape sequences of a unix terminal to HTML code"
HOMEPAGE="https://github.com/theZiz/aha"
SRC_URI="https://github.com/theZiz/aha/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv"

PATCHES=(
	"${FILESDIR}/${P}-null-ptr-dereference-fix.patch"
)

src_install() {
	emake PREFIX="${D}/usr" install
}
