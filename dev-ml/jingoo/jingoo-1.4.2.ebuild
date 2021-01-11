# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OCaml template engine almost compatible with Jinja2."
HOMEPAGE="https://github.com/tategakibunko/jingoo"
SRC_URI="https://github.com/tategakibunko/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/ppx_deriving
	dev-ml/uucp
	dev-ml/uutf
	dev-ml/menhir"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"
BDEPEND="dev-ml/dune"

src_install() {
	default
	rm -r "${D}"/usr/doc || die
}
