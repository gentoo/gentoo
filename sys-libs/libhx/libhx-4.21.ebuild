# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Platform independent library providing basic system functions"
HOMEPAGE="https://inai.de/projects/libhx/"
SRC_URI="https://inai.de/files/${PN}/libHX-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0/32" # soname version
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

BDEPEND="app-arch/xz-utils"

S="${WORKDIR}/libHX-${PV}"

src_install() {
	default

	if use doc; then
		dodoc doc/*.txt doc/*.rst
	fi

	find "${ED}" -name "*.la" -delete || die
}
