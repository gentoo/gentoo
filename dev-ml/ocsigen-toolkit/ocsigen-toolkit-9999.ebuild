# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib opam

DESCRIPTION="User interface widgets for Ocsigen applications"
HOMEPAGE="https://github.com/ocsigen/ocsigen-toolkit"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt debug"

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ocsigen/ocsigen-toolkit"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ocsigen/ocsigen-toolkit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RDEPEND="dev-lang/ocaml:=[ocamlopt?]
	>dev-ml/js_of_ocaml-2.7:=
	>=dev-ml/eliom-5.1:=[ppx]
	dev-ml/ppx_deriving:=
	dev-ml/calendar:=
	dev-ml/lwt:="
DEPEND="${RDEPEND}"

src_compile() {
	emake \
		DEBUG="$(usex debug yes no)" \
		NATIVE="$(usex ocamlopt yes no)" \
		all
}

src_install() {
	findlib_src_preinst
	OCAMLPATH="${OCAMLFIND_DESTDIR}" emake install
	opam_src_install
	dodoc README.md
}
