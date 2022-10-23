# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit python-single-r1

DESCRIPTION="Optional tools to help manage data in a mergerfs pool"
HOMEPAGE="https://github.com/trapexit/mergerfs-tools"
SRC_URI="https://dev.gentoo.org/~slashbeast/distfiles/${PN}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"

KEYWORDS="~amd64 ~riscv ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_compile() {
	# no build system.
	true
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
}
