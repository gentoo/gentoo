# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Regular expression library for OCaml"
HOMEPAGE="https://github.com/ocaml/ocaml-re"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml/ocaml-re.git"
else
	SRC_URI="https://github.com/ocaml/ocaml-re/archive/${PV}.tar.gz
		-> ocaml-${P}.tar.gz"
	S="${WORKDIR}/ocaml-${P}"

	KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
fi

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-ml/ocaml-re
	!<dev-ml/seq-0.3
	>=dev-lang/ocaml-4.09
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-ml/ounit2 )
"

PATCHES=( "${FILESDIR}/ounit2.patch" )

src_prepare() {
	default

	sed -i lib/dune -e "/(libraries seq)/d" || die
}
