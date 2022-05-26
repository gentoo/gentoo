# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An open, trustable and efficient SMT-prover"
HOMEPAGE="https://verit.loria.fr/"
SRC_URI="https://verit.loria.fr/download/${PV}/${P}-rmx.tar.gz"
S="${WORKDIR}/${P}-rmx"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/gmp:="
DEPEND="${RDEPEND}"

src_install() {
	default

	mv example examples || die
	insinto /usr/share/${PN}
	doins -r examples
}
