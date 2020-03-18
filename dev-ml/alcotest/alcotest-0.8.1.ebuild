# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit opam

DESCRIPTION="A lightweight and colourful test framework"
HOMEPAGE="https://github.com/mirage/alcotest/"
SRC_URI="https://github.com/mirage/alcotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/fmt:=
	dev-ml/astring:=
	dev-ml/cmdliner:=
	dev-ml/result:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/findlib"

src_compile() {
	jbuilder build -p alcotest || die
}

src_test() {
	jbuilder runtest -p alcotest || die
}
