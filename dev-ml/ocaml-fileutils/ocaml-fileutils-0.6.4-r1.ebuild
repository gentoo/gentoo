# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=fileutils

inherit dune

DESCRIPTION="Pure OCaml functions to manipulate real file (POSIX like) and filename"
HOMEPAGE="https://github.com/gildor478/ocaml-fileutils"
SRC_URI="https://github.com/gildor478/${PN}/releases/download/v${PV}/${DUNE_PKG_NAME}-${PV}.tbz -> ${P}.tar.bz2"
S="${WORKDIR}"/${DUNE_PKG_NAME}-${PV}

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="dev-ml/stdlib-shims:="
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

PATCHES=( "${FILESDIR}"/${P}-dune.patch )

DOCS=( CHANGES.md LICENSE.txt README.md )
