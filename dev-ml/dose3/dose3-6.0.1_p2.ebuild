# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Library to perform analysis on package repositories"
HOMEPAGE="http://www.mancoosi.org/software/ https://gforge.inria.fr/projects/dose"
SRC_URI="http://deb.debian.org/debian/pool/main/d/dose3/${PN}_$(ver_cut 1-3).orig.tar.gz"
SRC_URI+=" http://deb.debian.org/debian/pool/main/d/dose3/${PN}_${PV/_p/-}.debian.tar.xz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"

BDEPEND="
	dev-ml/findlib
	dev-ml/ocamlbuild
"
RDEPEND="
	>=dev-lang/ocaml-4.03:=[ocamlopt=]
	dev-ml/ocaml-base64:=[ocamlopt=]
	>=dev-ml/cudf-0.7:=[ocamlopt=]
	>=dev-ml/extlib-1.7.8:=[ocamlopt=]
	>=dev-ml/ocamlgraph-2.0.0:=[ocamlopt=]
	>=dev-ml/re-1.2.2:=[ocamlopt=]
	dev-ml/parmap:=[ocamlopt=]
	>=dev-ml/camlzip-1.08:=[ocamlopt=]
	>=dev-ml/camlbz2-0.7.0:=
	dev-ml/ocaml-expat:=[ocamlopt=]
	dev-ml/xml-light:=[ocamlopt=]
	app-arch/rpm
"
DEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[libyaml] )
"

# missing test data
RESTRICT="test"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default

	elog "Applying Debian patchset..."
	for file in "${WORKDIR}"/debian/patches/*.patch ; do
		eapply "${file}"
	done
}
