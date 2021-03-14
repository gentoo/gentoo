# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="File mapping"
HOMEPAGE="https://github.com/mirage/mmap"
SRC_URI="https://github.com/mirage/mmap/releases/download/v${PV}/${PN}-v${PV}.tbz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-v${PV}"
