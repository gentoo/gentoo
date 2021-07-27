# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	dev-ml/async_unix:=
	dev-ml/cmdliner:=
	dev-ml/core:=
	dev-ml/core_kernel:=
	dev-ml/duration:=
	>=dev-ml/fmt-0.8.9:=
	dev-ml/mirage-clock:=
	dev-ml/re:=
	dev-ml/result:=
	dev-ml/logs:=
	dev-ml/uutf:=
	dev-ml/uuidm:=
"
DEPEND="${RDEPEND}"
