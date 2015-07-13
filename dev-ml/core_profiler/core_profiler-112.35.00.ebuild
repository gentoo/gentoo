# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/core_profiler/core_profiler-112.35.00.ebuild,v 1.1 2015/07/13 18:48:04 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit eutils oasis

MY_P=${P/_/\~}
DESCRIPTION="Jane Street's profiling library"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-ml/core:=
	dev-ml/core_extended:=
	dev-ml/core_bench:=
	dev-ml/textutils:=
	dev-ml/pa_test:=
	dev-ml/pa_bench:=
	dev-ml/pa_ounit:=
	dev-ml/re2:=
"
DEPEND="${RDEPEND}"
DOCS=( "README.md" )
