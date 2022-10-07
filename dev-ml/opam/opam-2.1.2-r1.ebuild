# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A source-based package manager for OCaml"
HOMEPAGE="http://opam.ocaml.org/"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/dev-ml/opam/opam-2.1.0-dose3-6.patch.xz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"
RESTRICT="test" #see bugs 838658

RDEPEND="
	dev-ml/cmdliner:=
	dev-ml/cudf:=
	>=dev-ml/dose3-6.0:=
	dev-ml/extlib:=
	~dev-ml/opam-client-${PV}:=
	dev-ml/opam-file-format:=
	sys-apps/bubblewrap
	dev-ml/re:="
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}"/opam-2.1.0-dose3-6.patch )

src_prepare() {
	default

	cat <<- EOF >> "${S}/dune"
		(env
		 (dev
		  (flags (:standard -warn-error -3-9-33)))
		 (release
		  (flags (:standard -warn-error -3-9-33))))
	EOF
}
