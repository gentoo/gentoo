# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Invoke amd64 instructions (such as clz, popcnt, rdtsc, rdpmc)"
HOMEPAGE="https://github.com/janestreet/ocaml_intrinsics/"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt cpu_flags_x86_sse4_2"
RESTRICT="test"

DEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/dune-configurator:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	local supported_arch=false

	if use amd64 || use x86; then
		# On x86/amd64, we MUST have sse4_2 support for these stubs
		use cpu_flags_x86_sse4_2 && supported_arch=true
	elif use arm || use arm64; then
		supported_arch=true
	fi

	# If not a supported configuration, strip the stubs from the build
	if ! ${supported_arch}; then
		sed -i -e 's: crc_stubs::' src/dune || die
	fi

	default
}
