# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="QuickCheck inspired property-based testing for OCaml"
HOMEPAGE="https://github.com/c-cube/qcheck"
SRC_URI="https://github.com/c-cube/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ounit"

RDEPEND="
	ounit? ( >=dev-ml/ounit-2:= )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	oasis_configure_opts="
		$(use_enable ounit)
	" oasis_src_configure
}

DOCS=( CHANGELOG.md README.md )
