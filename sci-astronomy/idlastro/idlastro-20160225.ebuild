# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Astronomical user routines for IDL"
HOMEPAGE="http://idlastro.gsfc.nasa.gov/"
SRC_URI="${HOMEPAGE}/ftp/astron.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/gdl"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/gnudatalanguage/${PN}
	doins -r pro/*
	dodoc *txt text/*
}
