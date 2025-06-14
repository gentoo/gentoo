# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="Bigstring intrinsics and fast blits based on memcpy/memmove"
HOMEPAGE="https://github.com/inhabitedtype/bigstringaf"
SRC_URI="https://github.com/inhabitedtype/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-ml/dune-configurator
	test? ( dev-ml/alcotest )
"
