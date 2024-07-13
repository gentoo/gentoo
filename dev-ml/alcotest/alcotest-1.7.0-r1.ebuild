# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A lightweight and colourful test framework"
HOMEPAGE="https://github.com/mirage/alcotest/"
SRC_URI="https://github.com/mirage/alcotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/astring:=
	dev-ml/async:=[ocamlopt?]
	dev-ml/async_kernel:=[ocamlopt?]
	>=dev-ml/async_unix-0.15.0:=[ocamlopt?]
	dev-ml/base:=[ocamlopt?]
	dev-ml/cmdliner:=[ocamlopt?]
	>=dev-ml/core-0.15.0:=[ocamlopt?]
	>=dev-ml/core_unix-0.15.0:=[ocamlopt?]
	dev-ml/duration:=[ocamlopt?]
	dev-ml/fmt:=[ocamlopt?]
	dev-ml/lwt:=[ocamlopt?]
	dev-ml/mirage-clock:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/result:=[ocamlopt?]
	dev-ml/logs:=[ocamlopt?]
	dev-ml/uutf:=[ocamlopt?]
	dev-ml/uuidm:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.0"

src_prepare() {
	default

	if has_version '>=dev-ml/core_unix-0.16.0' ; then
		eapply "${FILESDIR}"/${P}-time_float_unix.patch
	fi
}
