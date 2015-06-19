# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/jsonm/jsonm-0.9.1.ebuild,v 1.1 2014/10/29 08:45:02 aballier Exp $

EAPI="5"
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Non-blocking streaming JSON codec for OCaml"
HOMEPAGE="http://erratique.ch/software/jsonm"
SRC_URI="http://erratique.ch/software/jsonm/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-ml/uutf:="
DEPEND="${RDEPEND}"

DOCS=( CHANGES README )

src_install() {
	oasis_src_install
	use doc && dohtml -r doc/*
}
