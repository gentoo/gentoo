# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A source-based package manager for OCaml"
HOMEPAGE="http://opam.ocaml.org/"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~x86"
IUSE="+ocamlopt"

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

# Cherry-picked from https://deb.debian.org/debian/pool/main/o/opam/opam_2.0.8-1.debian.tar.xz
PATCHES=( "${FILESDIR}/debian-Port-to-Dose3-6.0.1.patch" )

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
