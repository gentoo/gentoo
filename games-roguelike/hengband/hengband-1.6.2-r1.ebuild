# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools games

DESCRIPTION="An Angband variant, with a Japanese/fantasy theme"
HOMEPAGE="http://hengband.sourceforge.jp/en/"
SRC_URI="mirror://sourceforge.jp/hengband/10331/${P}.tar.bz2
	mirror://gentoo/${P}-mispellings.patch.gz"

KEYWORDS="ppc x86 ~x86-fbsd"
LICENSE="Moria"
SLOT="0"
IUSE="X linguas_ja"

RDEPEND=">=sys-libs/ncurses-5:0
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-libs/libXt )"

src_prepare() {
	# Removing Xaw dependency as is not used
	sed -i \
		-e '/Xaw/d' src/main-xaw.c \
		|| die
	sed -i \
		-e 's|root\.|root:|' lib/*/Makefile.in \
		|| die
	sed -i \
		-e 's:/games/:/:g' configure.in \
		|| die
	epatch \
		"../${P}"-mispellings.patch	\
		"${FILESDIR}/${P}"-added_faq.patch \
		"${FILESDIR}"/${P}-ovflfix.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf
	use linguas_ja || myconf="--disable-japanese"

	egamesconf \
		--with-setgid=${GAMES_GROUP} \
		$(use_with X x) \
		${myconf}
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	if use linguas_ja ; then
		dodoc readme.txt autopick.txt readme_eng.txt autopick_eng.txt
	else
		newdoc readme_eng.txt readme.txt
		newdoc autopick_eng.txt autopick.txt
	fi
	prepgamesdirs
	# FIXME: we need to patch around this BS
	fperms g+w "${GAMES_DATADIR}"/${PN}/lib/{apex,data,save,user}
}
