# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

# TODO: Wants quickcheck_deprecated?
RESTRICT="test"

RDEPEND="
	dev-ml/base:=
	<dev-ml/core_kernel-0.15:=
	<dev-ml/jst-config-0.15:=
	<dev-ml/ppx_jane-0.15:=
	<dev-ml/sexplib-0.15:=
	dev-ml/spawn:=
	dev-ml/stdio:=
	=dev-ml/timezone-0.14*:=
	<dev-ml/jane-street-headers-0.15:=
	!>=dev-ml/core_unix-0.15
"
DEPEND="${RDEPEND}"
