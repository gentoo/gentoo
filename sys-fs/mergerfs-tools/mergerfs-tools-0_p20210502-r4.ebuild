# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
MY_COMMIT="ff4ef0355f699eb11f0d75471d3df44c303830a3"

inherit python-single-r1

DESCRIPTION="Optional tools to help manage data in a mergerfs pool"
HOMEPAGE="https://github.com/trapexit/mergerfs-tools"
SRC_URI="https://github.com/trapexit/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"

KEYWORDS="~amd64 ~riscv ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

src_compile() {
	# no build system.
	true
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
}
