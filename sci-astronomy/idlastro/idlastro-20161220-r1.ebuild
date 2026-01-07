# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Astronomical user routines for IDL"
HOMEPAGE="https://idlastro.gsfc.nasa.gov/"
SRC_URI="https://idlastro.gsfc.nasa.gov/ftp/astron.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}

LICENSE="BSD-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="dev-lang/gdl"

src_install() {
	insinto /usr/share/gnudatalanguage/${PN}
	doins -r pro/*
	dodoc *txt text/*
}
