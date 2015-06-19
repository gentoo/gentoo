# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mp/mp-5.2.2.ebuild,v 1.12 2013/03/15 12:46:35 pinkbyte Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Minimum Profit: A text editor for programmers"
HOMEPAGE="http://www.triptico.com/software/mp.html"
SRC_URI="http://www.triptico.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-interix ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="gtk iconv kde ncurses nls pcre qt4"

MP_LINGUAS="de es it nl ru sv"
for mp_lingua in ${MP_LINGUAS}; do
	IUSE+=" linguas_${mp_lingua}"
done

RDEPEND="
	ncurses? ( sys-libs/ncurses )
	gtk? (
		|| ( x11-libs/gtk+:3 x11-libs/gtk+:2 )
		>=x11-libs/pango-1.8.0
		dev-libs/atk
		dev-libs/glib
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/cairo
	)
	!gtk? ( sys-libs/ncurses )
	app-text/grutatxt
	iconv? ( virtual/libiconv )
	nls? ( sys-devel/gettext )
	pcre? ( dev-libs/libpcre )
"
DEPEND="
	${RDEPEND}
	app-text/grutatxt
	virtual/pkgconfig
	dev-lang/perl
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gtk+.patch \
		"${FILESDIR}"/${PN}-5.2.1-prll.patch
	local mp_lingua
	for mp_lingua in ${MP_LINGUAS}; do
		if ! use linguas_${mp_lingua}; then
			rm po/${mp_lingua/linguas_/}.[mp]o || die
		fi
	done
	[[ $(ls po 2> /dev/null) ]] || \
		sed \
			-e '/^all/s:$(BUILDMO)::g' \
			-e '/^install/s:$(INSTALLMO)::g' \
			-i makefile.in || die
}

src_configure() {
	local myconf="--prefix=${EPREFIX}/usr --without-win32"

	if use gtk; then
		! use ncurses && myconf="${myconf} --without-curses"
	else
		myconf="${myconf} --without-gtk2"
	fi

	use iconv || myconf="${myconf} --without-iconv"

	use kde || myconf="${myconf} --without-kde4"

	use nls || myconfig="${myconf} --without-gettext"

	myconf="${myconf} $(use_with pcre)"
	use pcre || myconf="${myconf} --with-included-regex"

	use qt4 || myconf="${myconf} --without-qt4"

	tc-export AR CC
	sh config.sh ${myconf} || die "Configure failed"

	for i in "${S}" "${S}"/mpsl "${S}"/mpdm;do
		echo ${CFLAGS} >> $i/config.cflags
		echo ${CFLAGS} >> $i/config.ldflags
		echo ${LDFLAGS} >> $i/config.ldflags
	done
}

src_compile() {
	emake CPP="$(tc-getCXX)" CCLINK="$(tc-getCXX)"
}

src_install() {
	dodir /usr/bin
	sh config.sh --prefix="${EPREFIX}/usr"
	emake DESTDIR="${D}" install
}
