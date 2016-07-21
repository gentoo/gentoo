# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Cooperative light-weight thread library for OCaml"
SRC_URI="http://ocsigen.org/download/${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE="gtk +react +ssl"

DEPEND="react? ( dev-ml/react:= )
	dev-libs/libev
	ssl? ( >=dev-ml/ocaml-ssl-0.4.0:= )
	gtk? ( dev-ml/lablgtk:= dev-libs/glib:2 )"

RDEPEND="${DEPEND}
	!<www-servers/ocsigen-1.1"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

DOCS=( "CHANGES" "CHANGES.darcs" "README" )
PATCHES=( "${FILESDIR}/${P}-ocaml-4.01.patch" )

src_configure() {
	oasis_configure_opts="$(use_enable gtk glib)
		$(use_enable react)
		$(use_enable ssl)" \
		oasis_src_configure
}
