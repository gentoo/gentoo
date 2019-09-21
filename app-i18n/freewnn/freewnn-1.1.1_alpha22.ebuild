# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://freewnn.sourceforge.jp/ http://www.freewnn.org/"
SRC_URI="mirror://sourceforge.jp/${PN}/59257/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="ipv6"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-parallel-build.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)
DOCS="ChangeLog* CONTRIBUTORS"

src_prepare() {
	default

	sed -i \
		-e "s/WNNOWNER = wnn/WNNOWNER = root/" \
		-e "s/@INSTPGMFLAGS@//" \
		makerule.mk.in

	# bug #542534
	sed -i \
		-e "s/egrep -v/egrep -av/" \
		PubdicPlus/Makefile.in \
		Wnn/pubdicplus/Makefile.in \
		cWnn/[ct]dic/Makefile.in \
		kWnn/kdic/Makefile.in
}

src_configure() {
	econf \
		$(use_with ipv6) \
		--disable-cWnn \
		--disable-kWnn
}

src_install() {
	emake DESTDIR="${D}" install install.man
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
