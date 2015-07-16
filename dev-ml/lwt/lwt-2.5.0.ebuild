# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/lwt/lwt-2.5.0.ebuild,v 1.1 2015/07/16 12:50:15 aballier Exp $

EAPI=5

OASIS_BUILD_TESTS=1
# fails to build
#OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Cooperative light-weight thread library for OCaml"
SRC_URI="https://github.com/ocsigen/lwt/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE="gtk +react +ssl"

DEPEND="react? ( >=dev-ml/react-1.2:= )
	dev-libs/libev
	ssl? ( >=dev-ml/ocaml-ssl-0.4.0:= )
	gtk? ( dev-ml/lablgtk:= dev-libs/glib:2 )
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"

RDEPEND="${DEPEND}
	!<www-servers/ocsigen-1.1"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~x86-fbsd"

DOCS=( "CHANGES" "README.md" )

src_configure() {
	oasis_configure_opts="$(use_enable gtk glib)
		$(use_enable react)
		$(use_enable ssl)
		--enable-camlp4
		--disable-ppx" \
		oasis_src_configure
}
