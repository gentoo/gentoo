# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A lightweight and colourful test framework"
HOMEPAGE="https://github.com/mirage/alcotest/"
SRC_URI="https://github.com/mirage/alcotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/dune-2.8:=
	dev-ml/astring:=
	dev-ml/async_kernel:=
	dev-ml/async:=
	>=dev-ml/async_unix-0.15.0:=
	dev-ml/base:=
	dev-ml/cmdliner:=
	>=dev-ml/core-0.15.0:=
	>=dev-ml/core_unix-0.15.0:=
	dev-ml/duration:=
	>=dev-ml/fmt-0.8.9:=
	dev-ml/lwt:=
	dev-ml/mirage-clock:=
	dev-ml/re:=
	dev-ml/result:=
	dev-ml/logs:=
	dev-ml/uutf:=
	dev-ml/uuidm:=
"
DEPEND="${RDEPEND}"
