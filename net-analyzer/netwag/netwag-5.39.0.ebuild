# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# NOTE: netwib, netwox and netwag go together, bump all or bump none

EAPI=5

DESCRIPTION="Tcl/tk interface to netwox (Toolbox of 222 utilities for testing Ethernet/IP networks)"
HOMEPAGE="
	http://ntwag.sourceforge.net/
	http://www.laurentconstantin.com/en/netw/netwag/
"
SRC_URI="mirror://sourceforge/ntwag/${P}-src.tgz
	doc? ( mirror://sourceforge/ntwag/${P}-doc_html.tgz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="doc"

DEPEND="
	~net-analyzer/netwox-${PV}
	>=dev-lang/tk-8
	|| (
		x11-terms/xterm
		kde-apps/konsole
		x11-terms/eterm
		x11-terms/gnome-terminal
		x11-terms/rxvt
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src/src"

src_prepare() {
	sed -i \
		-e 's:/man$:/share/man:g' \
		-e "s:/usr/local:/usr:" \
		config.dat || die
	sed -i \
		-e 's|eterm|Eterm|g' \
		genemake || die
}

src_configure() {
	sh genemake || die "problem creating Makefile"
}

DOCS=(
	"${WORKDIR}"/${P}-src/README.TXT
	"${WORKDIR}"/${P}-src/doc/{changelog.txt,credits.txt}
	"${WORKDIR}"/${P}-src/doc/{problemreport.txt,problemusage.txt,todo.txt}
)

src_install() {
	default

	use doc && dohtml -r "${WORKDIR}"/${P}-doc_html/*
}
