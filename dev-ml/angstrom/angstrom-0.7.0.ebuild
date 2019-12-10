# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Parser combinators built for speed and memory efficiency"
HOMEPAGE="https://github.com/inhabitedtype/angstrom"
SRC_URI="https://github.com/inhabitedtype/angstrom/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/result:="
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	test? ( dev-ml/alcotest )"

src_compile() {
	jbuilder build -p ${PN} || die
}

src_test() {
	jbuilder runtest -p ${PN}
}
