# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools

DESCRIPTION="An Angband variant, with a Japanese/fantasy theme"
HOMEPAGE="http://hengband.sourceforge.jp/en/"
SRC_URI="mirror://sourceforge.jp/hengband/10331/${P}.tar.bz2
	mirror://gentoo/${P}-mispellings.patch.gz"

KEYWORDS="~x86"
LICENSE="Moria"
SLOT="0"
IUSE="X l10n_ja"

RDEPEND=">=sys-libs/ncurses-5:0
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-libs/libXt )"
BDEPEND="virtual/pkgconfig"

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
		"${FILESDIR}"/${P}-ovflfix.patch \
		"${FILESDIR}/${P}-autoconf-ncurses.patch"
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf=(
		--bindir="${EPREFIX}"/usr/bin
		--with-setgid="nobody"
		$(use_with X x)
	)
	use l10n_ja || myconf+=( --disable-japanese )

	econf "${myconf[@]}"
}

src_install() {
	default

	if use l10n_ja ; then
		dodoc readme.txt autopick.txt readme_eng.txt autopick_eng.txt
	else
		newdoc readme_eng.txt readme.txt
		newdoc autopick_eng.txt autopick.txt
	fi
}
