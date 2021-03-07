# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A front end for Taskwarrior (app-misc/task)"
HOMEPAGE="http://taskwarrior.org/wiki/taskwarrior/Vittk"
SRC_URI="http://taskwarrior.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/tcl:0"
RDEPEND="
	${DEPEND}
	app-misc/task
	dev-lang/tk:0
"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${PN}-1.1.1-dirs.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}
