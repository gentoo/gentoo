# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="opam repository libraries"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	~dev-ml/opam-format-${PV}:=
	dev-ml/re:=
	dev-ml/dose3:=
	dev-ml/opam-file-format:=
"
DEPEND="${RDEPEND}"

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
