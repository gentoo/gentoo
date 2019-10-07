# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

BACKPORTS="5cde0578d84926171b20c8f7e95a101e9b0b9457" # August 8, 2019

MY_P=${P%_p*}
MY_PV=${PV%_p*}

inherit eutils flag-o-matic python-single-r1 qmake-utils readme.gentoo-r1 systemd user vcs-snapshot

MYTHTV_BRANCH="fixes/${P%.*}"

DESCRIPTION="Open Source DVR and media center hub"
HOMEPAGE="https://www.mythtv.org"
SRC_URI="https://github.com/MythTV/mythtv/archive/${BACKPORTS}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"

IUSE_INPUT_DEVICES="input_devices_joystick"
IUSE_VIDEO_CAPTURE_DEVICES="v4l ivtv ieee1394 hdpvr hdhomerun vbox ceton"
IUSE="alsa altivec asi autostart bluray cdda cdr cec debug dvd dvb egl exif fftw jack java
	+lame lcd libass lirc +opengl oss perl pulseaudio python raw systemd vaapi vdpau vpx
	+wrapper x264 x265 +xml xmltv xnvctrl +xvid +X zeroconf
	${IUSE_INPUT_DEVICES} ${IUSE_VIDEO_CAPTURE_DEVICES}"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	bluray? ( xml )
	cdr? ( cdda )
"

# Some of the QA tests fail -- fix in next revision
RESTRICT="test"

COMMON="
	acct-user/mythtv
	dev-libs/glib:2
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	opengl? ( dev-qt/qtopengl:5 )
	dev-qt/qtscript:5
	dev-qt/qtsql:5[mysql]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	media-libs/freetype:2
	media-libs/libsamplerate
	media-libs/taglib
	lame? ( >=media-sound/lame-3.93.1 )
	sys-libs/zlib
	opengl? ( virtual/opengl )
	X? (
		x11-libs/libX11:=
		x11-libs/libXext:=
		x11-libs/libXinerama:=
		x11-libs/libXrandr:=
		x11-libs/libXv:=
		x11-libs/libXxf86vm:=
		x11-misc/wmctrl:=
	)
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	bluray? (
		media-libs/libbluray:=
		dev-libs/libcdio:=
		sys-fs/udisks:2
	)
	cec? ( dev-libs/libcec )
	dvd? (
		dev-libs/libcdio:=
		sys-fs/udisks:2
	)
	egl? ( media-libs/mesa[egl] )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	hdhomerun? ( media-libs/libhdhomerun )
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
	vaapi? ( x11-libs/libva:=[opengl] )
	vdpau? ( x11-libs/libvdpau )
	vpx? ( <media-libs/libvpx-1.8.0:= )
	xnvctrl? ( x11-drivers/nvidia-drivers:=[tools,static-libs] )
	x264? (	>=media-libs/x264-0.0.20111220:= )
	x265? (	media-libs/x265 )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.1.0 )
	zeroconf? (
		dev-libs/openssl:0=
		net-dns/avahi[mdnsresponder-compat]
	)
"
RDEPEND="${COMMON}
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
DEPEND="
	${COMMON}
	dev-lang/yasm
	x11-base/xorg-proto
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-respect_LDFLAGS.patch"
	"${FILESDIR}/${P}-cast_constants_to_short.patch"
	"${FILESDIR}/${P}-Fix_Dereferencing_type-punned_pointer.patch"
	"${FILESDIR}/${P}-Fix_unitialized_variables.patch"
)

# mythtv and mythplugins are separate builds in the github mythtv project
S="${WORKDIR}/${P}/mythtv"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
If a MYSQL server is installed, a mythtv MySQL user and mythconverg database
is created if it does not already exist.
You will be prompted for your MySQL root password.

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

Note that the systemd unit now restarts by default and logs
to journald via the console at the notice verbosity.
"

pkg_setup() {
	python-single-r1_pkg_setup
	# The acct-user/mythtv package creates/manages the user 'mythtv'
}

src_prepare() {
	default

	# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile || die "Cannot convert site_perl to vendor_perl!"

	# Fix up the version info since we are using the fixes/${PV} branch
	echo "SOURCE_VERSION=\"v${MY_PV}\"" > "${S}"/VERSION
	echo "BRANCH=\"${MYTHTV_BRANCH}\"" >> "${S}"/VERSION
	echo "SOURCE_VERSION=\"${BACKPORTS}\"" > "${S}"/EXPORTED_VERSION
	echo "BRANCH=\"${MYTHTV_BRANCH}\"" >> "${S}"/EXPORTED_VERSION

	echo "setting.extra -= -ldconfig" >> "${S}"/programs/mythfrontend/mythfrontend.pro
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
		$(use_enable xnvctrl)
		$(use_enable X xrandr)
		$(use_enable X xv)
	)

	# Hardware accellerators
	myconf+=(
		$(use_enable vdpau)
		$(use_enable vaapi)
		$(use_enable vaapi vaapi2)
		$(use_enable opengl opengl-video)
		$(use_enable opengl opengl-themepainter)
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

	einfo "Running ./configure ${myconf[@]} - THIS MAY TAKE A WHILE."
	./configure \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--qmake=$(qt5_get_bindir)/qmake \
		"${myconf[@]}"
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	dodoc AUTHORS UPGRADING README
	readme.gentoo_create_doc

	insinto /usr/share/mythtv/database
	doins database/*

	newinitd "${FILESDIR}"/mythbackend.init-r2 mythbackend
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
	# Ensure we don't install scripts needing the perl bindings (bug #516968)
	use perl || find contrib/ -name '*.pl' -exec rm -f {} \;
	# Ensure we don't install scripts needing the python bindings (bug #516968)
	use python || find contrib/ -name '*.py' -exec rm -f {} \;
	doins -r contrib/*

	# Install our mythfrontend wrapper which is similar to Mythbuntu's
	if use wrapper; then
		mv "${ED}/usr/bin/mythfrontend" "${ED}/usr/bin/mythfrontend.real" || die "Failed to install mythfrontend.real"
		newbin "${FILESDIR}"/mythfrontend.wrapper mythfrontend
		newconfd "${FILESDIR}"/mythfrontend.conf mythfrontend
	fi

	if use autostart; then
		echo CONFIG_PROTECT=\"$(egethome mythtv)\" > "${T}"/95mythtv
		doenvd "${T}"/95mythtv

		insinto $(egethome mythtv)
		newins "${FILESDIR}"/bash_profile .bash_profile
		newins "${FILESDIR}"/xinitrc-r1 .xinitrc
	fi

	# Make Python files executable
	find "${ED}/usr/share/mythtv" -type f -name '*.py' | while read file; do
		if [[ ! "${file##*/}" = "__init__.py" ]]; then
			chmod a+x "${file}" || die "Failed to make python file $(basename ${file}) executable"
		fi
	done

	# Ensure that Python scripts are executed by Python 2
	python_fix_shebang "${ED}/usr/share/mythtv"

	# Make shell & perl scripts executable
	find "${ED}" -type f -name '*.sh' -o -type f -name '*.pl' | \
		while read file; do
		chmod a+x "${file}" || die
	done
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
