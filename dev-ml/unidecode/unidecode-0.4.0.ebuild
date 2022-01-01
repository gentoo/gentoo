# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Convert unicode strings into its ASCII representation"
HOMEPAGE="https://github.com/geneweb/unidecode"
SRC_URI="https://github.com/geneweb/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="test? ( dev-ml/ounit2 )"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-test.patch )
