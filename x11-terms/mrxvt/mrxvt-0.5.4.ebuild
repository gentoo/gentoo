# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils

DESCRIPTION="Multi-tabbed rxvt clone with XFT, transparent background and CJK support"
HOMEPAGE="http://materm.sourceforge.net/"
SRC_URI="mirror://sourceforge/materm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

L10N_IUSE="l10n_el l10n_ja l10n_ko l10n_th l10n_zh-CN l10n_zh-TW"
IUSE="debug png jpeg session truetype menubar utempter xpm ${L10N_IUSE}"

RDEPEND="png? ( media-libs/libpng )
	utempter? ( sys-libs/libutempter )
	jpeg? ( virtual/jpeg )
	truetype? ( x11-libs/libXft
		media-libs/fontconfig
		media-libs/freetype
		elibc_uclibc? ( dev-libs/libiconv ) )
	x11-libs/libX11
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )
	x11-libs/libXrender"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	eapply "${FILESDIR}"/${P}-001-fix-segfault-when-wd-empty.patch
	eapply "${FILESDIR}"/${P}-libpng14.patch
	eapply_user

	eautoreconf

	if use elibc_uclibc && use truetype; then
		# It is stated in the README "Multichar support under XFT requires GNU iconv"
		sed -i -e 's/LIBS = @LIBS@/LIBS = @LIBS@ -liconv/' "${S}/src/Makefile.in"
	fi
}

src_configure() {
	local myconf

	# if you want to pass any other flags, use EXTRA_ECONF.
	if use l10n_el ; then
		myconf="${myconf} --enable-greek"
	fi
	if use l10n_ja ; then
		# --with-encoding=sjis
		myconf="${myconf} --enable-kanji --with-encoding=eucj"
	fi
	if use l10n_ko ; then
		myconf="${myconf} --enable-kr --with-encoding=kr"
	fi
	if use l10n_th ; then
		myconf="${myconf} --enable-thai"
	fi
	if use l10n_zh-CN ; then
		# --with-encoding=gbk
		myconf="${myconf} --enable-gb --with-encoding=gb"
	fi
	if use l10n_zh-TW ; then
		myconf="${myconf} --enable-big5 --with-encoding=big5"
	fi

	# 2006-03-13 gi1242: mrxvt works best with TERM=rxvt AND correctly set
	# termcap / terminfo entries. If the rxvt termcap / terminfo entries are
	# messed up then then it's better to set TERM=xterm.
	#
	# Provide support for this by setting the or RXVT_TERM environment variables
	# before emerging, as done in the rxvt ebuild.

	if [[ -n ${RXVT_TERM} ]]; then
		myconf="${myconf} --with-term=${RXVT_TERM}"
	fi

	econf \
		--enable-everything \
		--with-atab-extra=25 \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable xpm) \
		$(use_enable session sessionmgr) \
		$(use_enable truetype xft) \
		$(use_enable utempter) \
		$(use_enable menubar) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}"/usr/share/doc/${PF} install
	# Give mrxvt perms to update utmp
	fowners root:utmp /usr/bin/mrxvt
	fperms g+s /usr/bin/mrxvt
	dodoc AUTHORS CREDITS ChangeLog FAQ NEWS README* TODO
}

pkg_postinst() {
	if [[ -z $RXVT_TERM ]]; then
		einfo
		einfo "If you experience problems with curses programs, then this is"
		einfo "most likely because of incorrectly set termcap / terminfo"
		einfo "entries. To fix this you can dry and run (as user)"
		einfo "	tic /usr/share/doc/${P}/etc/mrxvt.terminfo"
		einfo "Alternately, run the offending programs with TERM=xterm."
		einfo
		einfo "To emerge mrxvt with TERM=xterm by default, set the RXVT_TERM"
		einfo "environment variable to 'xterm', or your desired default"
		einfo "terminal name. Alternately you can put 'Mrxvt.termName: xterm'"
		einfo "in your ~/.mrxvtrc, or /etc/mrxvt/mrxvtrc."
		einfo
	fi
}
