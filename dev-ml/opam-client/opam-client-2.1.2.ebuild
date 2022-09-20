# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="opam client libraries"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/dev-ml/opam/opam-2.1.0-dose3-6.patch.xz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/cmdliner:=
	~dev-ml/opam-repository-${PV}:=
	~dev-ml/opam-state-${PV}:=
	~dev-ml/opam-solver-${PV}:=
	dev-ml/opam-file-format:=
	dev-ml/re:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( sys-apps/bubblewrap )"

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
