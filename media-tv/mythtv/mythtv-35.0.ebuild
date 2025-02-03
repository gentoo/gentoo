# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISABLE_AUTOFORMATTING="yes"
PYTHON_COMPAT=( python3_{10..12} )

inherit edo flag-o-matic python-any-r1
inherit qmake-utils readme.gentoo-r1 systemd toolchain-funcs user-info

DESCRIPTION="Open Source DVR and media center hub"
HOMEPAGE="https://www.mythtv.org https://github.com/MythTV/mythtv"
if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT=
	SRC_URI="https://github.com/MythTV/mythtv/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the github MythTV project
	S="${WORKDIR}/mythtv-${MY_COMMIT}/mythtv"
else
	SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the github mythtv project
	S="${WORKDIR}/${P}/mythtv"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_INPUT_DEVICES="input_devices_joystick"
IUSE_VIDEO_CAPTURE_DEVICES="v4l ieee1394 hdhomerun vbox ceton"
IUSE="alsa asi autostart cdda cdr cec cpu_flags_ppc_altivec debug dvd dvb exif fftw jack java"
IUSE+=" +lame lcd libass lirc nvdec +opengl oss perl pulseaudio python raw systemd vaapi vdpau vpx"
IUSE+=" +wrapper x264 x265 +xml xmltv +xvid +X zeroconf"
IUSE+=" ${IUSE_INPUT_DEVICES} ${IUSE_VIDEO_CAPTURE_DEVICES}"
REQUIRED_USE="
	cdr? ( cdda )
"

RDEPEND="
	acct-user/mythtv
	dev-libs/glib:2
	dev-libs/lzo:2
	dev-libs/libzip:=
	dev-qt/qtbase:6[dbus,gui,mysql,network,sql,xml,widgets]
	media-fonts/corefonts
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/tex-gyre
	media-gfx/exiv2:=
	media-libs/freetype:2
	media-libs/libbluray:=[java?]
	media-libs/libsamplerate
	media-libs/libsoundtouch:=
	media-libs/taglib:=
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	autostart? (
		net-dialup/mingetty
		x11-apps/xset
		x11-wm/evilwm
	)
	cec? ( dev-libs/libcec )
	dvd? (
		dev-libs/libcdio:=
		media-libs/libdvdcss
		sys-fs/udisks:2
	)
	fftw? ( sci-libs/fftw:3.0=[threads] )
	hdhomerun? ( media-libs/libhdhomerun )
	ieee1394? (
		media-libs/libiec61883
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	jack? ( virtual/jack )
	lame? ( media-sound/lame )
	lcd? ( app-misc/lcdproc )
	libass? ( media-libs/libass:= )
	lirc? ( app-misc/lirc )
	nvdec? ( x11-drivers/nvidia-drivers )
	opengl? ( dev-qt/qtbase:6[opengl] )
	pulseaudio? ( media-libs/libpulse )
	systemd? ( sys-apps/systemd:= )
	vaapi? ( media-libs/libva:=[X] )
	vdpau? ( x11-libs/libvdpau )
	vpx? ( media-libs/libvpx:= )
	x264? (	media-libs/x264:= )
	X? (
		x11-apps/xinit
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXv
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
DEPEND="
	${RDEPEND}
	dev-lang/yasm
	sys-kernel/linux-headers
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
"
BDEPEND="
	virtual/pkgconfig
	opengl? ( virtual/opengl )
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/python-dateutil[${PYTHON_USEDEP}]
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/mysqlclient[${PYTHON_USEDEP}]
			dev-python/requests-cache[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-33.1-libva.patch
	"${FILESDIR}"/${PN}-35.no-ant-java-required-if-use-system-libblur.patch
)

python_check_deps() {
	use python || return 0
	python_has_version "dev-python/python-dateutil[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/lxml[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/mysqlclient[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/requests-cache[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use python && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Perl bits need to go into vendor_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile || die "Cannot convert site_perl to vendor_perl!"
}

src_configure() {
	local -a myconf=()

	# Setup paths
	myconf+=( --prefix="${EPREFIX}"/usr )
	myconf+=( --libdir="${EPREFIX}"/usr/$(get_libdir) )
	myconf+=( --libdir-name=$(get_libdir) )
	myconf+=( --mandir="${EPREFIX}"/usr/share/man )

	if use debug; then
		myconf+=( --compile-type=debug )
		myconf+=( --disable-stripping ) # FIXME: does not disable for all files, only for some
		myconf+=( --enable-valgrind ) # disables timeouts for valgrind memory debugging
	else
		myconf+=( --compile-type=release )
	fi

	# Build boosters
	has ccache "${FEATURES}" || myconf+=( --disable-ccache )
	has distcc "${FEATURES}" || myconf+=( --disable-distcc )

	# CPU settings
	# Mythtv's configure is borrowed from ffmpeg,
	# Bug #172723
	# Try to get cpu type based on CFLAGS.
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	local i
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[[ "${i}" == "native" ]] && i="host" # bug #273421
		myconf+=( --cpu="${i}" )
		break
	done
	myconf+=( $(use_enable cpu_flags_ppc_altivec altivec) )

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
		$(use_enable dvb)
		$(use_enable asi)
	)

	# Video Output Support
	myconf+=(
		$(use_enable X x11)
	)

	# Hardware accelerators
	myconf+=(
		$(use_enable nvdec)
		$(use_enable vaapi)
		$(use_enable vdpau)
		$(use_enable opengl)
		$(use_enable opengl egl)
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
		myconf+=( --with-bindings=perl,python )
	elif use perl; then
		myconf+=( --without-bindings=python )
		myconf+=( --with-bindings=perl )
	elif use python; then
		myconf+=( --without-bindings=perl )
		myconf+=( --with-bindings=python )
	else
		myconf+=( --without-bindings=perl,python )
	fi
	use python && myconf+=( --python="${EPYTHON}" )
	myconf+=( $(use_enable java bdjava) )

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
	myconf+=( --enable-symbol-visibility )
	myconf+=( --enable-pic )

	if tc-is-cross-compiler ; then
		myconf+=( --enable-cross-compile --arch=$(tc-arch-kernel) )
		myconf+=( --cross-prefix="${CHOST}"- )
	fi

	# econf sets these options that are not handled by configure:
	# --build --host --infodir --localstatedir --sysconfdir

	edo ./configure \
		--prefix="${EPREFIX}/usr" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--optflags="${CFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--qmake="$(qt6_get_bindir)"/qmake \
		"${myconf[@]}"
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	use python && python_optimize  # does all packages by default
	dodoc AUTHORS README
	readme.gentoo_create_doc

	insinto /usr/share/mythtv/database
	doins database/*

	newinitd "${FILESDIR}"/mythbackend.init-r3 mythbackend
	newconfd "${FILESDIR}"/mythbackend.conf-r1 mythbackend
	if use systemd; then
		systemd_newunit "${FILESDIR}"/mythbackend.service-28 mythbackend.service
	fi

	# The acct-user/mythtv package creates/manages the user 'mythtv'
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
	find "${ED}" -type f \( -name '*.sh' -o -name '*.pl' \) -exec chmod a+x {} \; \
		|| die "Failed to make script executable"
}

pkg_postinst() {
	readme.gentoo_print_elog
}

pkg_config() {
	if [[ -e "${EROOT}"/usr/bin/mysql ]]; then
		"${EROOT}"/usr/bin/mysql -u root -p < "${EROOT}"/usr/share/mythtv/database/mc.sql
	fi
}
