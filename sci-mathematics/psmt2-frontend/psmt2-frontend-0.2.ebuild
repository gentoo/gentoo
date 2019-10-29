# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit findlib autotools

DESCRIPTION="Library to parse and type-check an extension of the SMT-LIB 2 standard"
HOMEPAGE="https://github.com/OCamlPro-Coquera/psmt2-frontend"
SRC_URI="https://github.com/OCamlPro-Coquera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=dev-ml/menhir-20181006"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac}
	sed -i \
		-e "s:configure.in:configure.ac:g" \
		Makefile.in || die
	eautoreconf
}

src_compile() {
	emake depend
	default
}
