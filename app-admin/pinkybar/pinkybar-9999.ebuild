# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/su8/pinky-bar.git"

PYTHON_COMPAT=( python2_7 )

inherit git-r3 python-single-r1 autotools

DESCRIPTION="Gather some system information and show it in this statusbar program"
HOMEPAGE="https://github.com/su8/pinky-bar"

LICENSE="GPL-3"
SLOT="0"
IUSE="+alsa colours cpp drivetemp drivetemp-light dvd libnl lisp lua mpd ncurses
	+net +pci perl python2 r ruby sensors slang smartemp tcl weather x11"

DEPEND="
	sys-devel/autoconf
	>=sys-devel/automake-1.14.1
	sys-apps/gawk
	sys-devel/m4
	dev-lang/perl
"
RDEPEND="
	alsa? ( media-libs/alsa-lib )
	drivetemp? ( net-misc/curl app-admin/hddtemp )
	drivetemp-light? ( app-admin/hddtemp )
	dvd? ( dev-libs/libcdio )
	libnl? ( >=dev-libs/libnl-3.2.27 virtual/pkgconfig )
	lisp? ( dev-lisp/ecls )
	lua? ( dev-lang/lua )
	mpd? ( media-sound/mpd media-libs/libmpdclient )
	ncurses? ( sys-libs/ncurses )
	net? ( sys-apps/iproute2 )
	pci? ( sys-apps/pciutils )
	python2? ( ${PYTHON_DEPS} )
	r? ( dev-lang/R )
	ruby? ( dev-lang/ruby )
	sensors? ( sys-apps/lm_sensors )
	slang? ( sys-libs/slang )
	smartemp? ( sys-apps/smartmontools )
	tcl? ( dev-lang/tcl )
	weather? ( net-misc/curl app-arch/gzip )
	x11? ( x11-libs/libX11 )

"
REQUIRED_USE="
	drivetemp? ( !smartemp )
	drivetemp-light? ( !smartemp )
	ncurses? ( !x11 )
	smartemp? ( !drivetemp !drivetemp-light )
	x11? ( !ncurses )
"

src_prepare() {
	default

	elog 'Generating Makefiles'
	perl set.pl 'gentoo' || die
	eautoreconf -if
}

src_configure() {

	CONFIGURE_OPTS=(
		$(use_with alsa)
		$(use_with colours)
		$(use_with cpp)
		$(use_with drivetemp)
		$(use_with drivetemp-light)
		$(use_with dvd)
		$(use_with libnl)
		$(use_with lisp)
		$(use_with lua)
		$(use_with mpd)
		$(use_with ncurses)
		$(use_with net)
		$(use_with pci)
		$(use_with perl)
		$(use_with python2)
		$(use_with r)
		$(use_with ruby)
		$(use_with sensors)
		$(use_with slang)
		$(use_with smartemp)
		$(use_with tcl)
		$(use_with weather)
		$(use_with x11)
		api_key='28459ae16e4b3a7e5628ff21f4907b6f'
		icons='/usr/share/icons/xbm_icons'
	)
	econf "${CONFIGURE_OPTS[@]}"
}

src_compile() {
	emake
}

src_install() {
	if use colours && ! use x11 && ! use ncurses
	then
		insinto /usr/share/icons
		doins -r /extra/xbm_icons
	fi

	if use lisp
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.lisp
	fi
	if use lua
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.lua
	fi
	if use perl
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.pl
	fi
	if use python2
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.py
	fi
	if use r
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.R
	fi
	if use ruby
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.rb
	fi
	if use slang
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.sl
	fi
	if use tcl
	then
		insinto /usr/share/pinkysc
		doins "${S}"/extra/scripts/pinky.tcl
	fi

	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	use ncurses && elog 'You can combine the output from this program with pinky-curses'

	if use perl || use python2 || use lua ||
		use r || use ruby || use tcl || use slang || use lisp
	then
		elog 'The script(s) resides in /usr/share/pinkysc/'
	fi
}
