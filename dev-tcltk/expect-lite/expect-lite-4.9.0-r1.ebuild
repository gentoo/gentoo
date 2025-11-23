# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Quick and easy command line automation tool built on top of expect"
HOMEPAGE="https://expect-lite.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}_${PV}.tar.gz"
S=${WORKDIR}/${PN}.proj

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug examples"

RDEPEND="dev-tcltk/expect
	debug? ( dev-tcltk/tclx )"

DOCS=(
	bashrc ChangeLog README
)

src_install() {
	default

	docinto html
	dodoc -r Docs/*

	dobin ${PN}
	gunzip man/*.gz
	doman man/*

	if use examples ; then
		docinto examples
		ln -fs /usr/bin/expect-lite examples/expect-lite || die
		dodoc examples/*
	fi
}
