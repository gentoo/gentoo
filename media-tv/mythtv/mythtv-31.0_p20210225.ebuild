# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit eutils flag-o-matic python-any-r1 qmake-utils readme.gentoo-r1 systemd user-info

MY_COMMIT="b6ddf202a496dac180218a6581344251804f2086"

DESCRIPTION="Open Source DVR and media center hub"
HOMEPAGE="https://www.mythtv.org https://github.com/MythTV/mythtv"
if [[ $(ver_cut 3) == "p" ]] ; then
	SRC_URI="https://github.com/MythTV/mythtv/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the github MythTV project
	S="${WORKDIR}/mythtv-${MY_COMMIT}/mythtv"
else
	SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the github mythtv project
	S="${WORKDIR}/${P}/mythtv"
fi
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="0"

IUSE_INPUT_DEVICES="input_devices_joystick"
IUSE_VIDEO_CAPTURE_DEVICES="v4l ivtv ieee1394 hdpvr hdhomerun vbox ceton"
IUSE="alsa altivec asi autostart bluray cdda cdr cec debug dvd dvb egl exif fftw jack java
	+lame lcd libass lirc nvdec +opengl oss perl pulseaudio python raw systemd vaapi vdpau vpx
	+wrapper x264 x265 +xml xmltv +xvid +X zeroconf
	${IUSE_INPUT_DEVICES} ${IUSE_VIDEO_CAPTURE_DEVICES}"

REQUIRED_USE="
	bluray? ( xml )
	cdr? ( cdda )
"
RDEPEND="
	acct-user/mythtv
	dev-libs/glib:2
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[mysql]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-fonts/corefonts
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/tex-gyre
	media-gfx/exiv2:=
	media-libs/freetype:2
	media-libs/libsamplerate
	media-libs/taglib
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	autostart? (
		net-dialup/mingetty
		x11-apps/xset
		x11-wm/evilwm
	)
	bluray? (
		dev-libs/libcdio:=
		media-libs/libbluray:=[java?]
		sys-fs/udisks:2
	)
	cec? ( dev-libs/libcec )
	dvd? (
		dev-libs/libcdio:=
		media-libs/libdvdcss
		sys-fs/udisks:2
	)
	egl? ( media-libs/mesa[egl] )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	hdhomerun? ( media-libs/libhdhomerun )
	ieee1394? (
		media-libs/libiec61883
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	jack? ( virtual/jack )
	java? ( dev-java/ant-core )
	lame? ( media-sound/lame )
	lcd? ( app-misc/lcdproc )
	libass? ( media-libs/libass:= )
	lirc? ( app-misc/lirc )
	nvdec? ( x11-drivers/nvidia-drivers )
	opengl? ( dev-qt/qtopengl:5 )
	pulseaudio? ( media-sound/pulseaudio )
	systemd? ( sys-apps/systemd:= )
	vaapi? ( x11-libs/libva:=[opengl] )
	vdpau? ( x11-libs/libvdpau )
	vpx? ( media-libs/libvpx:= )
	x264? (	media-libs/x264:= )
	X? (
		x11-apps/xinit
		x11-libs/libX11:=
		x11-libs/libXext:=
		x11-libs/libXinerama:=
		x11-libs/libXrandr:=
		x11-libs/libXv:=
		x11-libs/libXxf86vm:=
		x11-misc/wmctrl:=
	)
	x265? (	media-libs/x265 )
	xml? ( dev-libs/libxml2:2 )
	xmltv? (
		dev-perl/XML-LibXML
		media-tv/xmltv
	 )
	xvid? ( media-libs/xvid )
	zeroconf? (
		dev-libs/openssl:=
		net-dns/avahi[mdnsresponder-compat]
	)
"
BDEPEND="
	virtual/pkgconfig
	opengl? ( virtual/opengl )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	dev-lang/yasm
	x11-base/xorg-proto
	perl? (
		dev-perl/DBD-mysql
		dev-perl/DBI
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-INET6
		dev-perl/LWP-Protocol-https
		dev-perl/Net-UPnP
		dev-perl/XML-Simple
	)
	python? (
		$(python_gen_any_dep '
			dev-python/python-dateutil[${PYTHON_USEDEP}]
			dev-python/future[${PYTHON_USEDEP}]
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/mysqlclient[${PYTHON_USEDEP}]
			dev-python/requests-cache[${PYTHON_USEDEP}]
			dev-python/simplejson[${PYTHON_USEDEP}]
		')
	)
"
python_check_deps() {
	use python || return 0
	has_version "dev-python/python-dateutil[${PYTHON_USEDEP}]" &&
	has_version "dev-python/future[${PYTHON_USEDEP}]" &&
	has_version "dev-python/lxml[${PYTHON_USEDEP}]" &&
	has_version "dev-python/mysqlclient[${PYTHON_USEDEP}]" &&
	has_version "dev-python/requests-cache[${PYTHON_USEDEP}]" &&
	has_version "dev-python/simplejson[${PYTHON_USEDEP}]"
}

PATCHES=(
	"${FILESDIR}/${PN}-30.0_p20190808-respect_LDFLAGS.patch"
)

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Support for metadata lookup changes is added. User configuration required.
Details at: https://www.mythtv.org/wiki/Metadata_Lookup_Changes_March_2021

Suppport for Python 2.7 is removed.

If a MYSQL server is installed, a mythtv MySQL user and mythconverg database
is created if it does not already exist.
You will be prompted for your MySQL root password.

A mythtv user is maintained by acct-user/mythtv. An existing mythtv user
may be modified to the configuration defined by acct-user/mythtv.
The mythtv user's primary group is now mythtv. (formerly video)
An existing mythtv user may be changed which may alter some functionality.
If it breaks mythtv you may need to (choose one):
	* Restore the original mythtv user
	* Create custom acct-user/mythtv overlay for your system
	* Fix you system to use mythtv as daemon only (recommended)
Failure to emerge acct-user/mythtv indicates that the existing mythtv user
is customized and not changed. Corrective action (choose one):
	* Ignore emerge failure
	* Create custom acct-user/mythtv overlay for your system
	* Fix you system to use mythtv as daemon only
	* Delete existing user and try again (dangerous)

Mythtv is updated to use correct FHS/Gentoo policy paths.
Updating mythtv installations may report:
	* mythtv is in use, cannot update home
	* There was an error when attempting to update the home directory for mythtv
	* Please update it manually on your system (as root):
	*       usermod -d "/var/lib/mythtv" "mythtv"
This can be ignored. The previous default was "/home/mythtv".
Use caution if you change the home directory.

To have this machine operate as recording host for MythTV,
mythbackend must be running. Run the following:
rc-update add mythbackend default

Your recordings folder must be owned 'mythtv'. e.g.
chown -R mythtv /var/lib/mythtv

Want mythfrontend to start automatically?
Set USE=autostart. Details can be found at:
https://dev.gentoo.org/~cardoe/mythtv/autostart.html
"

pkg_setup() {
	use python && python-any-r1_pkg_setup
	# The acct-user/mythtv package creates/manages the user 'mythtv'
}

src_prepare() {
	default

	# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile || die "Cannot convert site_perl to vendor_perl!"

}

src_configure() {
	local -a myconf

	# Setup paths
	myconf+=(--prefix="${EPREFIX}"/usr)
	myconf+=(--libdir="${EPREFIX}"/usr/$(get_libdir))
	myconf+=(--libdir-name=$(get_libdir))
	myconf+=(--mandir="${EPREFIX}"/usr/share/man)

	if use debug; then
		myconf+=(--compile-type=debug)
		myconf+=(--disable-stripping) # FIXME: does not disable for all files, only for some
		myconf+=(--enable-valgrind) # disables timeouts for valgrind memory debugging
	else
		myconf+=(--compile-type=release)
	fi

	# Build boosters
	has ccache "${FEATURES}" || myconf+=(--disable-ccache)
	has distcc "${FEATURES}" || myconf+=(--disable-distcc)

	# CPU settings
	# Mythtv's configure is borrowed from ffmpeg,
	# Bug #172723
	# Try to get cpu type based on CFLAGS.
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[ "${i}" = "native" ] && i="host" # bug #273421
		myconf+=(--cpu="${i}")
		break
	done
	myconf+=($(use_enable altivec))

	# Sound Output Support
	myconf+=(
		$(use_enable oss audio-oss)
		$(use_enable alsa audio-alsa)
		$(use_enable jack audio-jack)
		$(use_enable pulseaudio audio-pulseoutput)
	)

	# Input Support
	myconf+=(
		$(use_enable lirc)
		$(use_enable input_devices_joystick joystick-menu)
		$(use_enable cec libcec)
		$(use_enable ieee1394 firewire)
		$(use_enable hdhomerun)
		$(use_enable vbox)
		$(use_enable ceton)
		$(use_enable v4l v4l2)
		$(use_enable ivtv)
		$(use_enable hdpvr)
		$(use_enable dvb)
		$(use_enable asi)
	)

	# Video Output Support
	myconf+=(
		$(use_enable X x11)
		$(use_enable X xrandr)
	)

	# Hardware accellerators
	myconf+=(
		$(use_enable nvdec)
		$(use_enable vaapi)
		$(use_enable vdpau)
		$(use_enable opengl)
		$(use_enable libass)
	)

	# System tools
	myconf+=(
		$(use_enable systemd systemd_notify)
		$(use_enable systemd systemd_journal)
		$(use_enable xml libxml2)
		$(use_enable zeroconf libdns-sd)
	)

	# Bindings
	if use perl && use python; then
		myconf+=(--with-bindings=perl,python)
	elif use perl; then
		myconf+=(--without-bindings=python)
		myconf+=(--with-bindings=perl)
	elif use python; then
		myconf+=(--without-bindings=perl)
		myconf+=(--with-bindings=python)
	else
		myconf+=(--without-bindings=perl,python)
	fi
	use python && myconf+=(--python="${EPYTHON}")
	myconf+=($(use_enable java bdjava))

	# External codec library options (used for mythffmpeg and streaming transcode)
	# lame is required for some broadcasts for silence detection of commercials
	# default enable in IUSE with +lame
	myconf+=(
		$(use_enable lame libmp3lame)
		$(use_enable xvid libxvid)
		$(use_enable x264 libx264)
		$(use_enable x265 libx265)
		$(use_enable vpx libvpx)
	)

	# Clean up DSO load times and other compiler bits
	myconf+=(--enable-symbol-visibility)
	myconf+=(--enable-pic)

	if tc-is-cross-compiler ; then
		myconf+=(--enable-cross-compile --arch=$(tc-arch-kernel))
		myconf+=(--cross-prefix="${CHOST}"-)
	fi

	myconf+=($(use_enable bluray libbluray_external))

	# econf sets these options that are not handled by configure:
	# --build --host --infodir --localstatedir --sysconfdir

	einfo "Running ./configure ${myconf[@]} - THIS MAY TAKE A WHILE."
	./configure \
		--prefix="${EPREFIX}/usr" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--optflags="${CFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--qmake=$(qt5_get_bindir)/qmake \
		"${myconf[@]}"
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	use python && python_optimize  # does all packages by default
	dodoc AUTHORS UPGRADING README
	readme.gentoo_create_doc

	insinto /usr/share/mythtv/database
	doins database/*

	newinitd "${FILESDIR}"/mythbackend.init-r3 mythbackend
	newconfd "${FILESDIR}"/mythbackend.conf-r1 mythbackend
	if use systemd; then
		systemd_newunit "${FILESDIR}"/mythbackend.service-28 mythbackend.service
	fi

	dodoc keys.txt

	keepdir /etc/mythtv
	fowners -R mythtv /etc/mythtv
	keepdir /var/log/mythtv
	fowners -R mythtv /var/log/mythtv

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mythtv.logrotate.d-r4 mythtv

	insinto /usr/share/mythtv/contrib
	# Ensure we don't install scripts needing the perl bindings (bug #516968) Finding none is OK.
	if ! use perl; then
		find contrib/ -name '*.pl' -exec rm {} \;
	fi
	# Ensure we don't install scripts needing the python bindings (bug #516968) Finding none is OK.
	if ! use python; then
		find contrib/ -name '*.py' -exec rm {} \;
	fi
	doins -r contrib/*

	# Install our mythfrontend wrapper which is similar to Mythbuntu's
	if use wrapper; then
		mv "${ED}/usr/bin/mythfrontend" "${ED}/usr/bin/mythfrontend.real" || die "Failed to install mythfrontend.real"
		newbin "${FILESDIR}"/mythfrontend.wrapper mythfrontend
		newconfd "${FILESDIR}"/mythfrontend.conf mythfrontend
	fi

	if use autostart; then
		newenvd - 95mythtv <<- _EOF_
			CONFIG_PROTECT=\"$(egethome mythtv)\"
		_EOF_
		insinto $(egethome mythtv)
		newins "${FILESDIR}"/bash_profile .bash_profile
		newins "${FILESDIR}"/xinitrc-r1 .xinitrc
	fi

	# Make Python files executable but not files named "__init__.py"
	find "${ED}/usr/share/mythtv" -type f -name '*.py' -exec expr \( {} : '.*__init__.py' \) = 0 \; \
		-exec chmod a+x {} \; || die "Failed to make python file $(basename ${file}) executable"

	# Ensure that Python scripts are executed by Python 2
	use python && python_fix_shebang "${ED}/usr/share/mythtv"

	# Make shell & perl scripts executable
	find "${ED}" -type f \( -name '*.sh' -o -name '*.pl' \) -exec chmod a+x {} \; || die "Failed to make script executable"
}

pkg_postinst() {
	readme.gentoo_print_elog
}

pkg_info() {
	return
}

pkg_config() {
	if [[ -e "${EROOT}"/usr/bin/mysql ]]; then
		"${EROOT}"/usr/bin/mysql -u root -p < "${EROOT}"/usr/share/mythtv/database/mc.sql
	fi
}
