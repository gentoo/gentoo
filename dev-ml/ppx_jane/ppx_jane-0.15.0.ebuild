# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Standard Jane Street ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_jane"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base_quickcheck:${SLOT}
	dev-ml/ppx_bin_prot:${SLOT}
	dev-ml/ppx_disable_unused_warnings:${SLOT}
	dev-ml/ppx_expect:${SLOT}
	dev-ml/ppx_fixed_literal:${SLOT}
	dev-ml/ppx_ignore_instrumentation:${SLOT}
	dev-ml/ppx_log:${SLOT}
	dev-ml/ppx_module_timer:${SLOT}
	dev-ml/ppx_optional:${SLOT}
	dev-ml/ppx_pipebang:${SLOT}
	dev-ml/ppx_stable:${SLOT}
	dev-ml/ppx_string:${SLOT}
	dev-ml/ppx_typerep_conv:${SLOT}
"
RDEPEND="${DEPEND}"
