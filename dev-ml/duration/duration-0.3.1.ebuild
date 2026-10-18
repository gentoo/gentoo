# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Duration - conversions to various time units"
HOMEPAGE="https://github.com/hannesm/duration/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hannesm/${PN}"
else
	SRC_URI="https://github.com/hannesm/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="ISC"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-ml/alcotest )
"
