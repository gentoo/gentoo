# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

MY_PV="${PV/_/+}"
MY_P="${PN}-${PV/_/-}"

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/janestreet/jbuilder"
SRC_URI="https://github.com/janestreet/jbuilder/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/menhir )
"
OPAMSWITCH="system"

S="${WORKDIR}/${MY_P}"
OPAMROOT="${D}"

src_prepare() {
	# Disable Werror like behavior, doesnt build with ocaml 4.05 otherwise
	sed -i -e 's/--dev//' Makefile || die
}
