# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Cooperative light-weight thread library for OCaml"
SRC_URI="https://github.com/ocsigen/lwt/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE="+camlp4 +ppx"

DEPEND="
	dev-libs/libev
	>=dev-lang/ocaml-4.02:=
	dev-ml/result:=
	ppx? ( dev-ml/ppx_tools:= )
	camlp4? ( dev-ml/camlp4:= )"

RDEPEND="${DEPEND}
	!<www-servers/ocsigen-1.1"
DEPEND="${DEPEND}
	dev-ml/cppo"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~arm ~ppc ~x86-fbsd"

DOCS=( "CHANGES" "README.md" )

src_configure() {
	oasis_configure_opts="
		--disable-glib
		--disable-react
		--disable-ssl
		$(use_enable camlp4)
		$(use_enable ppx)" \
		oasis_src_configure
}
