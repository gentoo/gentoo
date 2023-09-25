# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Collection of programs that fit together to form a morse code tutor program"
HOMEPAGE="https://unixcw.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="alsa ncurses pulseaudio suid test qt5"
RESTRICT="!test? ( test )"

RDEPEND="ncurses? ( sys-libs/ncurses:= )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	sys-devel/libtool"

src_prepare() {
	append-cflags -std=gnu11
	append-cxxflags -std=gnu++11
	eapply -p0 "${FILESDIR}"/${PN}-3.6-tinfo.patch
	# Bug# 837617 and 858278
	sed -i -e "s/curses, initscr/ncurses, initscr/" \
		-e "s/_curses_initscr/_ncurses_initscr/" configure.ac || die
	eapply_user
	eautoreconf
}

src_configure() {
	econf --libdir="${EPREFIX}/usr/$(get_libdir)" \
		$(use_enable pulseaudio ) \
		$(use_enable alsa ) \
		$(use_enable ncurses cwcp ) \
		$(use_enable qt5 xcwcp ) \
		--disable-static
}

src_install() {
	default

	if ! use suid ; then
		fperms 711 /usr/bin/cw
		if use ncurses ; then
			fperms 711 /usr/bin/cwcp
		fi
		if use qt5 ; then
			fperms 711 /usr/bin/xcwcp
		fi
	fi

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	if use suid ; then
		ewarn "You have choosen to install 'cw', 'cwcp' and 'xcwcp' setuid"
		ewarn "by setting USE=suid."
		ewarn "Be aware that this is a security risk and not recommended."
		ewarn ""
		ewarn "These files do only need root access if you want to use the"
		ewarn "PC speaker for morse sidetone output. You can alternativly"
		ewarn "drop USE=suid and use sudo."
	else
		elog "Be aware that 'cw', 'cwcp' and 'xcwcp' needs root access if"
		elog "you want to use the PC speaker for morse sidetone output."
		elog "You can call the programs via sudo for that (see 'man sudo')."
	fi
}
