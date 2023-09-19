# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A lightweight and colourful test framework"
HOMEPAGE="https://github.com/mirage/alcotest/"
SRC_URI="https://github.com/mirage/alcotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/dune-2.8:=
	dev-ml/astring:=
	dev-ml/async_unix:0/0.14.0
	dev-ml/cmdliner:=
	dev-ml/core:=
	dev-ml/core_kernel:=
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
BDEPEND="test? ( >=dev-ml/cmdliner-1.1.0 )"

src_prepare() {
	cp "${FILESDIR}"/unknown_option.processed \
		test/e2e/alcotest/failing/unknown_option.expected \
		|| die
	default
}
