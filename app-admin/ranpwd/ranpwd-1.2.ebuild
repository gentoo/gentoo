# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generate random passwords using the in-kernel cryptographically"
HOMEPAGE="https://www.kernel.org/pub/software/utils/admin/ranpwd/"
SRC_URI="https://www.kernel.org/pub/software/utils/admin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"

src_test() {
	einfo "generating random passwords"
	for a in 1 2 3 4 5 6 7 8 9
	do
		./ranpwd $(($a * 10))
	done
}

src_install() {
	emake INSTALLROOT="${D}" install
}
