# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_PN=${PN/moo/MOO-light}
MY_P=${P/moo/MOO-light}
DESCRIPTION="MOO Client written in Tcl/Tk"
HOMEPAGE="http://www.awns.com/tkMOO-light/"
SRC_URI="http://www.awns.com/tkMOO-light/Source/${MY_P}.tar.gz"

LICENSE="tkMOO"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	>=dev-lang/tcl-8.3.3:0=
	>=dev-lang/tk-8.3.3:0="
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PV}-Makefile-noclean.patch"
		"${FILESDIR}/${PV}-keys-workaround.patch"
)

src_compile() {
	emake \
		WISH="$(type -P wish)" \
		TKMOO_LIB_DIR="/usr/$(get_libdir)/${MY_PN}" \
		TKMOO_BIN_DIR=/usr/bin
}

src_install() {
	emake \
		TKMOO_LIB_DIR="${D}/usr/$(get_libdir)/${MY_PN}" \
		TKMOO_BIN_DIR="${D}/usr/bin" \
		install
	dodoc README dot.tkmoolightrc bugsmail.txt
	dosym tkMOO-lite /usr/bin/tkmoo
	make_desktop_entry tkmoo "tkMOO"
}
