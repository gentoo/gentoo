# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-single-r1

MY_COMMIT="80d6c9511da554009415d67e7c0ead1256c1fc41"

DESCRIPTION="Optional tools to help manage data in a mergerfs pool"
HOMEPAGE="https://github.com/trapexit/mergerfs-tools"
SRC_URI="https://github.com/trapexit/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"

src_compile() {
	# no build system.
	true
}

src_install() {
	# Explicit INSTALL= to avoid `which`
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr INSTALL=install install
	python_fix_shebang "${ED}"
}
