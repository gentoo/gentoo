# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="sqlite,ssl"
LIBDVDCSS_VERSION="1.4.2-Leia-Beta-5"
LIBDVDREAD_VERSION="6.0.0-Leia-Alpha-3"
LIBDVDNAV_VERSION="6.0.0-Leia-Alpha-3"
FFMPEG_VERSION="4.3.2"
CODENAME="Matrix"
FFMPEG_KODI_VERSION="19.1"
PYTHON_COMPAT=( python3_{8,9} )
SRC_URI="https://github.com/xbmc/libdvdcss/archive/${LIBDVDCSS_VERSION}.tar.gz -> libdvdcss-${LIBDVDCSS_VERSION}.tar.gz
	https://github.com/xbmc/libdvdread/archive/${LIBDVDREAD_VERSION}.tar.gz -> libdvdread-${LIBDVDREAD_VERSION}.tar.gz
	https://github.com/xbmc/libdvdnav/archive/${LIBDVDNAV_VERSION}.tar.gz -> libdvdnav-${LIBDVDNAV_VERSION}.tar.gz
	!system-ffmpeg? ( https://github.com/xbmc/FFmpeg/archive/${FFMPEG_VERSION}-${CODENAME}-${FFMPEG_KODI_VERSION}.tar.gz -> ffmpeg-${PN}-${FFMPEG_VERSION}-${CODENAME}-${FFMPEG_KODI_VERSION}.tar.gz )"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/xbmc/xbmc.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
else
	MY_PV=${PV/_p/_r}
	MY_PV=${MY_PV/_alpha/a}
	MY_PV=${MY_PV/_beta/b}
	MY_PV=${MY_PV/_rc/RC}
	MY_P="${PN}-${MY_PV}"
	SRC_URI+=" https://github.com/xbmc/xbmc/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm arm64 ~x86"
	S=${WORKDIR}/xbmc-${MY_PV}
fi

PATCHES=(
	"${FILESDIR}/${P}-fmt-8.patch"
)

inherit autotools cmake desktop linux-info pax-utils python-single-r1 xdg

DESCRIPTION="A free and open source media-player and entertainment hub"
HOMEPAGE="https://kodi.tv/ https://kodi.wiki/"

LICENSE="GPL-2+"
SLOT="0"
# use flag is called libusb so that it doesn't fool people in thinking that
# it is _required_ for USB support. Otherwise they'll disable udev and
# that's going to be worse.
IUSE="airplay alsa bluetooth bluray caps cec +css dav1d dbus eventclients gbm gles lcms libusb lirc mariadb mysql nfs +optical power-control pulseaudio raspberry-pi samba +system-ffmpeg test udf udev udisks upnp upower vaapi vdpau wayland webserver +X +xslt zeroconf"
IUSE="${IUSE} cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_arm_neon"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( gbm wayland X )
	?? ( mariadb mysql )
	bluray? ( udf )
	udev? ( !libusb )
	udisks? ( dbus )
	upower? ( dbus )
	power-control? ( dbus )
	vdpau? (
		X
		!gles
		!gbm
	)
	zeroconf? ( dbus )
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/lzo-2.04
	>=dev-libs/flatbuffers-1.12.0:=
	>=media-libs/libjpeg-turbo-2.0.4:=
	>=media-libs/libpng-1.6.26:0=
"
COMMON_TARGET_DEPEND="${PYTHON_DEPS}
	airplay? (
		>=app-pda/libplist-2.0.0
		net-libs/shairplay
	)
	alsa? ( >=media-libs/alsa-lib-1.1.4.1 )
	bluetooth? ( net-wireless/bluez )
	bluray? ( >=media-libs/libbluray-1.1.2 )
	caps? ( sys-libs/libcap )
	dbus? ( sys-apps/dbus )
	dev-db/sqlite
	dev-libs/crossguid
	>=dev-libs/fribidi-1.0.5
	cec? ( >=dev-libs/libcec-4.0[raspberry-pi?] )
	dev-libs/libpcre[cxx]
	>=dev-libs/spdlog-1.5.0:=
	dev-libs/tinyxml[stl]
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	')
	>=dev-libs/libcdio-2.1.0[cxx]
	>=dev-libs/libfmt-6.1.2
	dev-libs/libfstrcmp
	gbm? (
		>=dev-libs/libinput-1.10.5
		media-libs/mesa[gbm(+)]
		x11-libs/libxkbcommon
	)
	gles? (
		!raspberry-pi? ( media-libs/mesa[gles2] )
	)
	lcms? ( media-libs/lcms:2 )
	libusb? ( virtual/libusb:1 )
	virtual/ttf-fonts
	media-fonts/roboto
	>=media-libs/freetype-2.10.1
	>=media-libs/libass-0.13.4
	!raspberry-pi? ( media-libs/mesa[egl(+)] )
	>=media-libs/taglib-1.11.1
	system-ffmpeg? (
		>=media-video/ffmpeg-${FFMPEG_VERSION}:=[dav1d?,encode,postproc]
		media-video/ffmpeg[openssl]
	)
	!system-ffmpeg? (
		app-arch/bzip2
		dav1d? ( media-libs/dav1d )
	)
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
	>=net-misc/curl-7.68.0[http2]
	nfs? ( >=net-fs/libnfs-2.0.0:= )
	!gles? ( media-libs/glu )
	>=dev-libs/openssl-1.0.2l:0=
	raspberry-pi? (
		|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin media-libs/mesa[egl(+),gles2,video_cards_vc4] )
	)
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( >=net-fs/samba-3.4.6[smbclient(+)] )
	>=sys-libs/zlib-1.2.11
	udf? ( >=dev-libs/libudfread-1.0.0 )
	udev? ( virtual/udev )
	vaapi? (
		x11-libs/libva:=
		!gles? ( x11-libs/libva[opengl] )
		system-ffmpeg? ( media-video/ffmpeg[vaapi] )
		vdpau? ( x11-libs/libva-vdpau-driver )
		wayland? ( x11-libs/libva[wayland] )
		X? ( x11-libs/libva[X] )
	)
	virtual/libiconv
	vdpau? (
		|| ( >=x11-libs/libvdpau-1.1 >=x11-drivers/nvidia-drivers-180.51 )
		system-ffmpeg? ( media-video/ffmpeg[vdpau] )
	)
	wayland? (
		>=dev-cpp/waylandpp-0.2.3:=
		media-libs/mesa[wayland]
		>=dev-libs/wayland-protocols-1.7
		>=x11-libs/libxkbcommon-0.4.1
	)
	webserver? ( >=net-libs/libmicrohttpd-0.9.55[messages(+)] )
	X? (
		media-libs/mesa[X]
		!gles? ( media-libs/libglvnd[X] )
		x11-libs/libX11
		x11-libs/libXrandr
		x11-libs/libXrender
		system-ffmpeg? ( media-video/ffmpeg[X] )
	)
	x11-libs/libdrm
	xslt? (
		dev-libs/libxslt
		>=dev-libs/libxml2-2.9.4
	)
	zeroconf? ( net-dns/avahi[dbus] )
"
RDEPEND="${COMMON_DEPEND} ${COMMON_TARGET_DEPEND}
	lirc? ( app-misc/lirc )
	power-control? ( || ( sys-apps/systemd sys-auth/elogind ) )
	udisks? ( sys-fs/udisks:2 )
	upower? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND} ${COMMON_TARGET_DEPEND}
	dev-libs/rapidjson
	test? ( >=dev-cpp/gtest-1.10.0 )
"
BDEPEND="${COMMON_DEPEND}
	dev-lang/swig
	dev-util/cmake
	media-libs/giflib
	>=dev-libs/flatbuffers-1.11.0
	>=media-libs/libjpeg-turbo-2.0.4:=
	>=media-libs/libpng-1.6.26:0=
	virtual/pkgconfig
	virtual/jre
"

CONFIG_CHECK="~IP_MULTICAST"
ERROR_IP_MULTICAST="
In some cases Kodi needs to access multicast addresses.
Please consider enabling IP_MULTICAST under Networking options.
"

pkg_setup() {
	check_extra_config
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	cmake_src_prepare

	# avoid long delays when powerkit isn't running #348580
	sed -i \
		-e '/dbus_connection_send_with_reply_and_block/s:-1:3000:' \
		xbmc/platform/linux/*.cpp || die

	# Prepare tools and libs witch are configured with autotools during compile time
	AUTOTOOLS_DIRS=(
		"${S}"/tools/depends/native/TexturePacker/src
		"${S}"/tools/depends/native/JsonSchemaBuilder/src
	)

	local d
	for d in "${AUTOTOOLS_DIRS[@]}" ; do
		pushd ${d} >/dev/null || die
		AT_NOELIBTOOLIZE="yes" AT_TOPLEVEL_EAUTORECONF="yes" eautoreconf
		popd >/dev/null || die
	done
	elibtoolize

	# Prevent autoreconf rerun
	sed -e 's/autoreconf -vif/echo "autoreconf already done in src_prepare()"/' -i \
		"${S}"/tools/depends/native/TexturePacker/src/autogen.sh \
		"${S}"/tools/depends/native/JsonSchemaBuilder/src/autogen.sh \
		|| die
}

src_configure() {
	local platform=()
	use gbm && platform+=( gbm )
	use wayland && platform+=( wayland )
	use X && platform+=( x11 )
	local core_platform_name="${platform[@]}"
	local mycmakeargs=(
		-DENABLE_SSE=$(usex cpu_flags_x86_sse)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DENABLE_SSE4_2=$(usex cpu_flags_x86_sse4_2)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2)
		-DENABLE_NEON=$(usex cpu_flags_arm_neon)
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-DVERBOSE=ON
		-DENABLE_LDGOLD=OFF # https://bugs.gentoo.org/show_bug.cgi?id=606124
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AIRTUNES=$(usex airplay)
		-DENABLE_AVAHI=$(usex zeroconf)
		-DENABLE_BLUETOOTH=$(usex bluetooth)
		-DENABLE_BLURAY=$(usex bluray)
		-DENABLE_CCACHE=OFF
		-DENABLE_CLANGFORMAT=OFF
		-DENABLE_CLANGTIDY=OFF
		-DENABLE_CPPCHECK=OFF
		-DENABLE_ISO9660PP=$(usex optical)
		-DENABLE_CEC=$(usex cec)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_DVDCSS=$(usex css)
		-DENABLE_EVENTCLIENTS=ON # alway enable to have 'kodi-send' and filter extra staff in 'src_install()'
		-DENABLE_INTERNAL_CROSSGUID=OFF
		-DENABLE_INTERNAL_RapidJSON=OFF
		-DENABLE_INTERNAL_FMT=OFF
		-DENABLE_INTERNAL_FFMPEG="$(usex !system-ffmpeg)"
		-DENABLE_INTERNAL_FSTRCMP=OFF
		-DENABLE_INTERNAL_FLATBUFFERS=OFF
		-DENABLE_INTERNAL_DAV1D=OFF
		-DENABLE_INTERNAL_GTEST=OFF
		-DENABLE_INTERNAL_UDFREAD=OFF
		-DENABLE_INTERNAL_SPDLOG=OFF
		-DENABLE_CAP=$(usex caps)
		-DENABLE_LCMS2=$(usex lcms)
		-DENABLE_LIRCCLIENT=$(usex lirc)
		-DENABLE_MARIADBCLIENT=$(usex mariadb)
		-DENABLE_MDNS=OFF # used only on Android
		-DENABLE_MICROHTTPD=$(usex webserver)
		-DENABLE_MYSQLCLIENT=$(usex mysql)
		-DENABLE_NFS=$(usex nfs)
		-DENABLE_OPENGLES=$(usex gles)
		-DENABLE_OPENGL=$(usex !gles)
		-DENABLE_OPTICAL=$(usex optical)
		-DENABLE_PLIST=$(usex airplay)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_SMBCLIENT=$(usex samba)
		-DENABLE_SNDIO=OFF
		-DENABLE_TESTING=$(usex test)
		-DENABLE_UDEV=$(usex udev)
		-DENABLE_UDFREAD=$(usex udf)
		-DENABLE_UPNP=$(usex upnp)
		-DENABLE_VAAPI=$(usex vaapi)
		-DENABLE_VDPAU=$(usex vdpau)
		-DENABLE_XSLT=$(usex xslt)
		-Dlibdvdread_URL="${DISTDIR}/libdvdread-${LIBDVDREAD_VERSION}.tar.gz"
		-Dlibdvdnav_URL="${DISTDIR}/libdvdnav-${LIBDVDNAV_VERSION}.tar.gz"
		-Dlibdvdcss_URL="${DISTDIR}/libdvdcss-${LIBDVDCSS_VERSION}.tar.gz"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DAPP_RENDER_SYSTEM="$(usex gles gles gl)"
		-DCORE_PLATFORM_NAME="${core_platform_name}"
	)

	use !udev && mycmakeargs+=( -DENABLE_LIBUSB=$(usex libusb) )

	use X && use !gles && mycmakeargs+=( -DENABLE_GLX=ON )

	if use system-ffmpeg; then
		mycmakeargs+=( -DWITH_FFMPEG="yes" )
	else
		mycmakeargs+=( -DFFMPEG_URL="${DISTDIR}/ffmpeg-${PN}-${FFMPEG_VERSION}-${CODENAME}-${FFMPEG_KODI_VERSION}.tar.gz" )
	fi

	if ! echo "${CFLAGS}" | grep -Fwqe '-DNDEBUG' - && ! echo "${CFLAGS}" | grep -Fwqe '-D_DEBUG' - ; then
		CFLAGS+=' -DNDEBUG' # Kodi requires one of the 'NDEBUG' or '_DEBUG' defines
		CXXFLAGS+=' -DNDEBUG'
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all
}

src_test() {
	# see https://github.com/xbmc/xbmc/issues/17860#issuecomment-630120213
	KODI_HOME="${BUILD_DIR}" cmake_build check
}

src_install() {
	cmake_src_install

	pax-mark Em "${ED}"/usr/$(get_libdir)/${PN}/${PN}.bin

	newicon media/icon48x48.png kodi.png

	rm "${ED}"/usr/share/kodi/addons/skin.estuary/fonts/Roboto-Thin.ttf || die
	dosym ../../../../fonts/roboto/Roboto-Thin.ttf \
		usr/share/kodi/addons/skin.estuary/fonts/Roboto-Thin.ttf

	if use !eventclients ; then
		rm -f "${ED}"/usr/bin/kodi-ps3remote || die
		rm -f "${D}"$(python_get_sitedir)/kodi/ps3_remote.py || die
		rm -rf "${D}"$(python_get_sitedir)/kodi/ps3 || die
		rm -rf "${D}"$(python_get_sitedir)/kodi/bt || die
		rm -rf "${ED}"/usr/share/doc/${PF}/kodi-eventclients-dev || die
	fi

	python_optimize "${D}$(python_get_sitedir)"
}
