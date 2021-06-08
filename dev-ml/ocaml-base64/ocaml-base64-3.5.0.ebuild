# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="base64"
inherit dune

DESCRIPTION="Library for radix-64 representation (de)coding"
HOMEPAGE="https://github.com/mirage/ocaml-base64"
SRC_URI="https://github.com/mirage/ocaml-base64/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-ml/rresult dev-ml/bos dev-ml/alcotest )"
