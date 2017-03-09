# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils virtualx

DESCRIPTION="A flexible listbox widget for Tk"
HOMEPAGE="http://tktreectrl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="X debug shellicon threads"

RDEPEND=">=dev-lang/tk-8.4"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/2.2.9-as-needed.patch
}

src_configure() {
	econf \
	$(use_enable threads) \
	$(use_enable shellicon) \
	$(use_enable amd64 64bit) \
	$(use_enable debug symbols) \
	$(use_enable X x) \
	--enable-shared
}

src_test() {
	Xemake test
}

src_install() {
	default
	mv "${ED}"/usr/lib*/treectrl${PV}/htmldoc "${ED}"/usr/share/doc/${P}/
}
