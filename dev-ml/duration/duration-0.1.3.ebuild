# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Duration - conversions to various time units"
HOMEPAGE="https://github.com/hannesm/duration"
SRC_URI="https://github.com/hannesm/duration/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-ml/alcotest )"
