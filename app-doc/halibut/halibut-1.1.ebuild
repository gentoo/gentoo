# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="yet another free document preparation system"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	tc-export CC
	CFLAGS="${CFLAGS} ${CPPFLAGS}" \
	LFLAGS="${LDFLAGS}" \
	emake -j1 \
		BUILDDIR="${S}/build" \
		VERSION="${PV}"

	emake -C doc
}

src_install() {
	dobin build/halibut
	doman doc/halibut.1
	dodoc doc/halibut.txt
	dohtml doc/*.html
}
