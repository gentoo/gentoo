# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

# git diff --relative=mythtv v0.27.6.. > ~/mythtv-0.27.6/patches/mythtv.patch
BACKPORTS="d8a2db77f5731cf32c6d31127452391c6cf7f91f"
MY_P=${P%_p*}
MY_PV=${PV%_p*}

inherit flag-o-matic python-single-r1 qmake-utils user readme.gentoo-r1 systemd vcs-snapshot

MYTHTV_BRANCH="fixes/29"

DESCRIPTION="Homebrew PVR project"
HOMEPAGE="https://www.mythtv.org"
SRC_URI="https://github.com/MythTV/mythtv/archive/${BACKPORTS}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"

IUSE_INPUT_DEVICES="input_devices_joystick"
IUSE="alsa altivec autostart bluray cec debug dvb dvd egl fftw +hls \
	ieee1394 jack lcd libass lirc mythlogserver perl pulseaudio python systemd +theora \
	vaapi vdpau +vorbis +wrapper +xml xmltv +xvid zeroconf ${IUSE_INPUT_DEVICES}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	bluray? ( xml )
	theora? ( vorbis )
"

COMMON="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[mysql]
	dev-qt/qtopengl:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	media-libs/freetype:2
	media-libs/taglib
	>=media-sound/lame-3.93.1
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXv
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	x11-misc/wmctrl
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	bluray? (
		dev-libs/libcdio:=
		media-libs/libbluray:=
		sys-fs/udisks:2
	)
	cec? ( dev-libs/libcec )
	dvd? (
		dev-libs/libcdio:=
		sys-fs/udisks:2
	)
	egl? ( media-libs/mesa[egl] )
	fftw? ( sci-libs/fftw:3.0= )
	hls? (
		<media-libs/libvpx-1.8.0:=
		>=media-libs/x264-0.0.20111220:=
	)
	ieee1394? (
		>=media-libs/libiec61883-1.0.0
		>=sys-libs/libavc1394-0.5.3
		>=sys-libs/libraw1394-1.2.0
	)
	jack? ( media-sound/jack-audio-connection-kit )
	lcd? ( app-misc/lcdproc )
	libass? ( >=media-libs/libass-0.9.11:= )
	lirc? ( app-misc/lirc )
	perl? (
		>=dev-perl/libwww-perl-5
		dev-perl/DBD-mysql
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-INET6
		dev-perl/LWP-Protocol-https
		dev-perl/Net-UPnP
	)
	pulseaudio? ( media-sound/pulseaudio )
	python? (
		${PYTHON_DEPS}
		dev-python/lxml
		dev-python/mysql-python
		dev-python/urlgrabber
		dev-python/future
		dev-python/requests-cache
	)
	systemd? ( sys-apps/systemd:= )
	theora? ( media-libs/libtheora media-libs/libogg )
	vaapi? ( x11-libs/libva:=[opengl] )
	vdpau? ( x11-libs/libvdpau )
	vorbis? ( >=media-libs/libvorbis-1.0 media-libs/libogg )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.1.0 )
	zeroconf? (
		dev-libs/openssl:0=
		net-dns/avahi[mdnsresponder-compat]
	)
"
RDEPEND="${COMMON}
	!media-tv/mythtv-bindings
	!x11-themes/mythtv-themes
	media-fonts/corefonts
	media-fonts/dejavu
	media-fonts/liberation-fonts
	x11-apps/xinit
	autostart? (
		net-dialup/mingetty
		x11-apps/xset
		x11-wm/evilwm
	)
	dvd? ( media-libs/libdvdcss )
	xmltv? ( >=media-tv/xmltv-0.5.43 )
"
DEPEND="${COMMON}
	dev-lang/yasm
	virtual/pkgconfig
	x11-base/xorg-proto
"

S="${WORKDIR}/${P}-r1/mythtv"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
If a MYSQL server is installed, a mythtv MySQL user and mythconverg database
is created if it does not already exist.
You will be prompted for your MySQL root password.

To have this machine operate as recording host for MythTV,
mythbackend must be running. Run the following:
rc-update add mythbackend default

Your recordings folder must be owned 'mythtv'. e.g.
chown -R mythtv /var/lib/mythtv

Want mythfrontend to start automatically?
Set USE=autostart. Details can be found at:
https://dev.gentoo.org/~cardoe/mythtv/autostart.html

Note that the systemd unit now restarts by default and logs
to journald via the console at the notice verbosity.
"

MYTHTV_GROUPS="video,audio,tty,uucp"

PATCHES=( "${FILESDIR}/${P}-exiv2-0.27.1.patch" ) # bug 691904

pkg_setup() {
	python-single-r1_pkg_setup
	enewuser mythtv -1 /bin/bash /home/mythtv ${MYTHTV_GROUPS}
	usermod -a -G ${MYTHTV_GROUPS} mythtv
}

src_prepare() {
	default

	# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile

	# Fix up the version info since we are using the fixes/${PV} branch
	echo "SOURCE_VERSION=\"v${MY_PV}\"" > "${S}"/VERSION
	echo "BRANCH=\"${MYTHTV_BRANCH}\"" >> "${S}"/VERSION
	echo "SOURCE_VERSION=\"${BACKPORTS}\"" > "${S}"/EXPORTED_VERSION
	echo "BRANCH=\"${MYTHTV_BRANCH}\"" >> "${S}"/EXPORTED_VERSION

	echo "setting.extra -= -ldconfig" >> "${S}"/programs/mythfrontend/mythfrontend.pro
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
	myconf="${myconf} --enable-libmp3lame" # lame is not optional it is required for some broadcasts for silence detection of commercials
	use cec || myconf="${myconf} --disable-libcec"
	use zeroconf || myconf="${myconf} --disable-libdns-sd"
	myconf="${myconf} $(use_enable theora libtheora)"
	myconf="${myconf} $(use_enable vorbis libvorbis)"

	if use hls; then
		myconf="${myconf} --enable-libx264"
		myconf="${myconf} --enable-libvpx"
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

	use python && myconf="${myconf} --python=${EPYTHON}"

	if use debug; then
		myconf="${myconf} --compile-type=debug"
	else
		myconf="${myconf} --compile-type=release"
		#myconf="${myconf} --enable-debug" does nothing per sphery
		myconf="${myconf} --disable-stripping" # FIXME: does not disable for all files, only for some
	fi

	# Video
	myconf="${myconf} $(use_enable vdpau)"
	myconf="${myconf} $(use_enable vaapi)"

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

	myconf="${myconf} $(use_enable systemd systemd_notify)"
	myconf="${myconf} $(use_enable systemd systemd_journal)"
	use systemd || myconf="${myconf} $(use_enable mythlogserver)"

	chmod +x ./external/FFmpeg/version.sh

	einfo "Running ./configure ${myconf}"
	./configure \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--qmake=$(qt5_get_bindir)/qmake \
		${myconf} || die "configure died"
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	dodoc AUTHORS UPGRADING README
	readme.gentoo_create_doc

	insinto /usr/share/mythtv/database
	doins database/*

	newinitd "${FILESDIR}"/mythbackend.init-r2 mythbackend
	newconfd "${FILESDIR}"/mythbackend.conf-r1 mythbackend
	systemd_newunit "${FILESDIR}"/mythbackend.service-28 mythbackend.service

	dodoc keys.txt

	keepdir /etc/mythtv
	chown -R mythtv "${ED}"/etc/mythtv
	keepdir /var/log/mythtv
	chown -R mythtv "${ED}"/var/log/mythtv
	dodir /var/log/mythtv/old

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mythtv.logrotate.d-r4 mythtv

	insinto /usr/share/mythtv/contrib
	# Ensure we don't install scripts needing the perl bindings (bug #516968)
	use perl || find contrib/ -name '*.pl' -exec rm -f {} \;
	# Ensure we don't install scripts needing the python bindings (bug #516968)
	use python || find contrib/ -name '*.py' -exec rm -f {} \;
	doins -r contrib/*

	# Install our mythfrontend wrapper which is similar to Mythbuntu's
	if use wrapper; then
		mv "${ED}/usr/bin/mythfrontend" "${ED}/usr/bin/mythfrontend.real"
		newbin "${FILESDIR}"/mythfrontend.wrapper mythfrontend
		newconfd "${FILESDIR}"/mythfrontend.conf mythfrontend
	fi

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
	python_fix_shebang "${ED}/usr/share/mythtv"

	# Make shell & perl scripts executable
	find "${ED}" -type f -name '*.sh' -o -type f -name '*.pl' | \
		while read file; do
		chmod a+x "${file}"
	done

	# Remove empty dir
	rmdir "${ED}"/var/log/mythtv/old
}

pkg_preinst() {
	export CONFIG_PROTECT="${CONFIG_PROTECT} ${EROOT}/home/mythtv/"
}

pkg_postinst() {
	readme.gentoo_print_elog
}

pkg_info() {
	if [[ -f "${EROOT}"/usr/bin/mythfrontend ]]; then
		"${EROOT}"/usr/bin/mythfrontend --version
	fi
}

pkg_config() {
	if [[ -e "${EROOT}"/usr/bin/mysql ]]; then
		"${EROOT}"/usr/bin/mysql -u root -p < "${EROOT}"/usr/share/mythtv/database/mc.sql
	fi
}
