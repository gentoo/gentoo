# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="python? 2:2.6"
BACKPORTS="b305eb5b7fc662146e74983fa3754d622695cdeb"
MY_P=${P%_p*}

inherit flag-o-matic multilib eutils python user systemd

MYTHTV_VERSION="v0.27.4"
MYTHTV_BRANCH="fixes/0.27"

DESCRIPTION="Homebrew PVR project"
HOMEPAGE="http://www.mythtv.org"
SRC_URI="https://github.com/MythTV/mythtv/archive/v0.27.4.tar.gz -> mythtv-0.27.4.tar.gz
	${BACKPORTS:+http://dev.gentoo.org/~rich0/distfiles/${MY_P}-${BACKPORTS}.tar.xz}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE_INPUT_DEVICES="input_devices_joystick"
IUSE="alsa altivec libass autostart bluray cec crystalhd debug dvb dvd \
egl fftw +hls ieee1394 jack lcd lirc perl pulseaudio python raop +theora \
vaapi vdpau +vorbis +xml xmltv +xvid ${IUSE_INPUT_DEVICES}"

REQUIRED_USE="
	bluray? ( xml )
	theora? ( vorbis )"

COMMON="
	>=media-libs/freetype-2.0:=
	sys-libs/zlib:=
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXinerama:=
	x11-libs/libXv:=
	x11-libs/libXrandr:=
	x11-libs/libXxf86vm:=
	>=dev-qt/qtcore-4.7.2:4=
	>=dev-qt/qtdbus-4.7.2:4=
	>=dev-qt/qtgui-4.7.2:4=
	>=dev-qt/qtscript-4.7.2:4=
	>=dev-qt/qtsql-4.7.2:4=[mysql]
	>=dev-qt/qtopengl-4.7.2:4=[egl?]
	>=dev-qt/qtwebkit-4.7.2:4=
	x11-misc/wmctrl:=
	virtual/mysql:=
	virtual/opengl:=
	alsa? ( >=media-libs/alsa-lib-1.0.24:= )
	bluray? (
		dev-libs/libcdio:=
		media-libs/libbluray:=
	)
	cec? ( dev-libs/libcec:= )
	dvb? (
		media-libs/libdvb:=
		virtual/linuxtv-dvb-headers:=
	)
	dvd? ( dev-libs/libcdio:= )
	egl? ( media-libs/mesa:=[egl] )
	fftw? ( sci-libs/fftw:3.0= )
	hls? (
		media-libs/faac:=
		media-libs/libvpx:=
		>=media-libs/x264-0.0.20111220:=
		>=media-sound/lame-3.93.1
	)
	ieee1394? (
		>=sys-libs/libraw1394-1.2.0:=
		>=sys-libs/libavc1394-0.5.3:=
		>=media-libs/libiec61883-1.0.0:=
	)
	jack? ( media-sound/jack-audio-connection-kit )
	lcd? ( app-misc/lcdproc )
	libass? ( >=media-libs/libass-0.9.11:= )
	lirc? ( app-misc/lirc )
	perl? (
		dev-perl/DBD-mysql
		dev-perl/Net-UPnP
		dev-perl/LWP-Protocol-https
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-INET6
		>=dev-perl/libwww-perl-5
	)
	pulseaudio? ( media-sound/pulseaudio )
	python? (
		dev-python/mysql-python
		dev-python/lxml
		dev-python/urlgrabber
	)
	raop? (
		dev-libs/openssl:=
		net-dns/avahi[mdnsresponder-compat]
	)
	theora? ( media-libs/libtheora:= media-libs/libogg:= )
	vaapi? ( x11-libs/libva:= )
	vdpau? ( x11-libs/libvdpau:= )
	vorbis? ( >=media-libs/libvorbis-1.0:= media-libs/libogg:= )
	xml? ( >=dev-libs/libxml2-2.6.0:= )
	xvid? ( >=media-libs/xvid-1.1.0:= )
	!media-tv/mythtv-bindings
	!x11-themes/mythtv-themes
	media-libs/taglib:=
	dev-libs/glib:=
	"

RDEPEND="${COMMON}
	media-fonts/corefonts
	media-fonts/dejavu
	media-fonts/liberation-fonts
	x11-apps/xinit
	autostart? (
		net-dialup/mingetty
		x11-wm/evilwm
		x11-apps/xset
	)
	dvd? ( media-libs/libdvdcss:= )
	xmltv? ( >=media-tv/xmltv-0.5.43 )
	"

DEPEND="${COMMON}
	dev-lang/yasm
	x11-proto/xineramaproto
	x11-proto/xf86vidmodeproto
	"

S="${WORKDIR}/${MY_P}/mythtv"

MYTHTV_GROUPS="video,audio,tty,uucp"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	enewuser mythtv -1 /bin/bash /home/mythtv ${MYTHTV_GROUPS}
	usermod -a -G ${MYTHTV_GROUPS} mythtv
}

src_prepare() {
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/../patches" \
			epatch

	# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile

	# Fix up the version info since we are using the fixes/${PV} branch
	echo "SOURCE_VERSION=\"${MYTHTV_VERSION}\"" > "${S}"/VERSION
	echo "BRANCH=\"${MYTHTV_BRANCH}\"" >> "${S}"/VERSION

	echo "setting.extra -= -ldconfig" >> "${S}"/programs/mythfrontend/mythfrontend.pro

	epatch "${FILESDIR}/libdir-27.patch"

	epatch_user
}

src_configure() {
	local myconf=

	# Setup paths
	myconf="${myconf} --prefix=${EPREFIX}/usr"
	myconf="${myconf} --libdir=${EPREFIX}/usr/$(get_libdir)"
	myconf="${myconf} --libdir-name=$(get_libdir)"
	myconf="${myconf} --mandir=${EPREFIX}/usr/share/man"

	# Audio
	myconf="${myconf} $(use_enable alsa audio-alsa)"
	myconf="${myconf} $(use_enable jack audio-jack)"
	use pulseaudio || myconf="${myconf} --disable-audio-pulseoutput"

	use altivec    || myconf="${myconf} --disable-altivec"
	myconf="${myconf} $(use_enable dvb)"
	myconf="${myconf} $(use_enable ieee1394 firewire)"
	myconf="${myconf} $(use_enable lirc)"
	myconf="${myconf} $(use_enable xvid libxvid)"
	myconf="${myconf} --dvb-path=/usr/include"
	myconf="${myconf} --enable-xrandr"
	myconf="${myconf} --enable-xv"
	myconf="${myconf} --enable-x11"
	myconf="${myconf} --enable-nonfree"
	use cec || myconf="${myconf} --disable-libcec"
	use raop || myconf="${myconf} --disable-libdns-sd"
	myconf="${myconf} $(use_enable theora libtheora)"
	myconf="${myconf} $(use_enable vorbis libvorbis)"

	if use hls; then
		myconf="${myconf} --enable-libmp3lame"
		myconf="${myconf} --enable-libx264"
		myconf="${myconf} --enable-libvpx"
		myconf="${myconf} --enable-libfaac"
	fi

	myconf="${myconf} $(use_enable libass)"

	if use perl && use python; then
		myconf="${myconf} --with-bindings=perl,python"
	elif use perl; then
		myconf="${myconf} --without-bindings=python"
		myconf="${myconf} --with-bindings=perl"
	elif use python; then
		myconf="${myconf} --without-bindings=perl"
		myconf="${myconf} --with-bindings=python"
	else
		myconf="${myconf} --without-bindings=perl,python"
	fi

	use python && myconf="${myconf} --python=$(PYTHON)"

	if use debug; then
		myconf="${myconf} --compile-type=debug"
	else
		myconf="${myconf} --compile-type=release"
		#myconf="${myconf} --enable-debug" does nothing per sphery
		#myconf="${myconf} --disable-stripping" does nothing per sphery
	fi

	# Video
	use vdpau && myconf="${myconf} --enable-vdpau"
	myconf="${myconf} $(use_enable vaapi)"
	use crystalhd && myconf="${myconf} --enable-crystalhd"

	# Input
	use input_devices_joystick || myconf="${myconf} --disable-joystick-menu"

	# Clean up DSO load times and other compiler bits
	myconf="${myconf} --enable-symbol-visibility"
	myconf="${myconf} --enable-pic"

	# CPU settings
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[ "${i}" = "native" ] && i="host"
		myconf="${myconf} --cpu=${i}"
		break
	done

	if tc-is-cross-compiler ; then
		myconf="${myconf} --enable-cross-compile --arch=$(tc-arch-kernel)"
		myconf="${myconf} --cross-prefix=${CHOST}-"
	fi

	# Build boosters
	has distcc ${FEATURES} || myconf="${myconf} --disable-distcc"
	has ccache ${FEATURES} || myconf="${myconf} --disable-ccache"

	chmod +x ./external/FFmpeg/version.sh

	einfo "Running ./configure ${myconf}"
	./configure \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		${myconf} || die "configure died"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
	dodoc AUTHORS UPGRADING README

	insinto /usr/share/mythtv/database
	doins database/*

	newinitd "${FILESDIR}"/mythbackend.init mythbackend
	newconfd "${FILESDIR}"/mythbackend.conf mythbackend
	systemd_dounit "${FILESDIR}"/mythbackend.service

	dodoc keys.txt

	keepdir /etc/mythtv
	chown -R mythtv "${ED}"/etc/mythtv
	keepdir /var/log/mythtv
	chown -R mythtv "${ED}"/var/log/mythtv
	dodir /var/log/mythtv/old

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mythtv.logrotate.d-r4 mythtv

	insinto /usr/share/mythtv/contrib
	doins -r contrib/*

	# Install our mythfrontend wrapper which is similar to Mythbuntu's
	mv "${ED}/usr/bin/mythfrontend" "${ED}/usr/bin/mythfrontend.real"
	newbin "${FILESDIR}"/mythfrontend.wrapper mythfrontend
	newconfd "${FILESDIR}"/mythfrontend.conf mythfrontend

	if use autostart; then
		dodir /etc/env.d/
		echo 'CONFIG_PROTECT="/home/mythtv/"' > "${ED}"/etc/env.d/95mythtv

		insinto /home/mythtv
		newins "${FILESDIR}"/bash_profile .bash_profile
		newins "${FILESDIR}"/xinitrc-r1 .xinitrc
	fi

	# Make Python files executable
	find "${ED}/usr/share/mythtv" -type f -name '*.py' | while read file; do
		if [[ ! "${file##*/}" = "__init__.py" ]]; then
			chmod a+x "${file}"
		fi
	done

	# Ensure that Python scripts are executed by Python 2
	python_convert_shebangs -q -r 2 "${ED}/usr/share/mythtv"

	# Make shell & perl scripts executable
	find "${ED}" -type f -name '*.sh' -o -type f -name '*.pl' | \
		while read file; do
		chmod a+x "${file}"
	done
}

pkg_preinst() {
	export CONFIG_PROTECT="${CONFIG_PROTECT} ${EROOT}/home/mythtv/"
}

pkg_postinst() {
	use python && python_mod_optimize MythTV

	elog "To have this machine operate as recording host for MythTV, "
	elog "mythbackend must be running. Run the following:"
	elog "rc-update add mythbackend default"
	elog
	elog "Your recordings folder must be owned 'mythtv'. e.g."
	elog "chown -R mythtv /var/lib/mythtv"

	elog "Want mythfrontend to start automatically?"
	elog "Set USE=autostart. Details can be found at:"
	elog "http://dev.gentoo.org/~cardoe/mythtv/autostart.html"
	elog
	elog "Note that the systemd unit now restarts by default and logs"
	elog "to journald via the console at the notice verbosity."
}

pkg_postrm() {
	use python && python_mod_cleanup MythTV
}

pkg_info() {
	if [[ -f "${EROOT}"/usr/bin/mythfrontend ]]; then
		"${EROOT}"/usr/bin/mythfrontend --version
	fi
}

pkg_config() {
	echo "Creating mythtv MySQL user and mythconverg database if it does not"
	echo "already exist. You will be prompted for your MySQL root password."
	"${EROOT}"/usr/bin/mysql -u root -p < "${EROOT}"/usr/share/mythtv/database/mc.sql
}
