# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="OCaml Binding to Cairo"
HOMEPAGE="https://github.com/Chris00/ocaml-cairo"
SRC_URI="https://github.com/Chris00/ocaml-cairo/releases/download/0.5/cairo2-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="gtk"

DEPEND="
	gtk? ( dev-ml/lablgtk:= )
	x11-libs/cairo
"
RDEPEND="${DEPEND}"
DOCS=( README.md )
S="${WORKDIR}/cairo2-${PV}/"

src_configure() {
	oasis_configure_opts="$(use_enable gtk lablgtk2)" oasis_src_configure
}
