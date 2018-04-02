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
IUSE="+alsa colors drivetemp drivetemp-light dvd dwm ip keyboard libnl lisp lua
	mouse mpd ncurses numcapslock +net +pci perl python2 r ruby sensors slang
	smartemp tcl"

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
	dwm? ( x11-libs/libX11 )
	ip? ( net-misc/curl app-arch/gzip )
	keyboard? ( x11-libs/libX11 )
	libnl? ( >=dev-libs/libnl-3.2.27 virtual/pkgconfig )
	lisp? ( dev-lisp/ecls )
	lua? ( dev-lang/lua )
	mouse? ( x11-libs/libX11 )
	mpd? ( media-sound/mpd media-libs/libmpdclient )
	ncurses? ( sys-libs/ncurses )
	numcapslock? ( x11-libs/libX11 )
	net? ( sys-apps/iproute2 )
	pci? ( sys-apps/pciutils )
	python2? ( ${PYTHON_DEPS} )
	r? ( dev-lang/R )
	ruby? ( dev-lang/ruby )
	sensors? ( sys-apps/lm_sensors )
	slang? ( sys-libs/slang )
	smartemp? ( sys-apps/smartmontools )
	tcl? ( dev-lang/tcl )

"
REQUIRED_USE="
	drivetemp? ( !smartemp )
	drivetemp-light? ( !smartemp )
	dwm? ( !ncurses )
	ncurses? ( !dwm )
	smartemp? ( !drivetemp !drivetemp-light )
"

src_prepare() {
	default

	einfo 'Generating Makefiles'
	perl set.pl 'gentoo' || die
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with alsa)
		$(use_with colors)
		$(use_with drivetemp)
		$(use_with drivetemp-light)
		$(use_with dvd)
		$(use_with dwm)
		$(use_with ip)
		$(use_with keyboard)
		$(use_with libnl)
		$(use_with lisp)
		$(use_with lua)
		$(use_with mouse)
		$(use_with mpd)
		$(use_with ncurses)
		$(use_with numcapslock)
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
		icons='/usr/share/icons/xbm_icons'
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake
}

src_install() {
	local scripts_path="${S}/extra/scripts"

	if use colors && ! use dwm && ! use ncurses
	then
		insinto /usr/share/icons
		doins -r extra/xbm_icons
	fi

	insinto /usr/share/pinkysc
	use lua && doins "${scripts_path}/pinky.lua"
	use perl && doins "${scripts_path}/pinky.pl"
	use python2 && doins "${scripts_path}/pinky.py"
	use r && doins "${scripts_path}/pinky.R"
	use ruby && doins "${scripts_path}/pinky.rb"
	use slang && doins "${scripts_path}/pinky.sl"
	use tcl && doins "${scripts_path}/pinky.tcl"

	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	use ncurses && elog 'You can combine the output from this program with pinky-curses'

	if use lisp || use lua || use perl || use python2 ||
		use r || use ruby || use slang || use tcl
	then
		elog 'The script(s) resides in /usr/share/pinkysc/'
	fi
}
