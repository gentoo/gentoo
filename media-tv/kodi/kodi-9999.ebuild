# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Does not work with py3 here
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils linux-info python-single-r1 cmake-utils autotools

LIBDVDCSS_COMMIT="2f12236bc1c92f73c21e973363f79eb300de603f"
LIBDVDREAD_COMMIT="17d99db97e7b8f23077b342369d3c22a6250affd"
LIBDVDNAV_COMMIT="43b5f81f5fe30bceae3b7cecf2b0ca57fc930dac"
FFMPEG_VERSION="3.1.6"
CODENAME="Krypton"
SRC_URI="https://github.com/xbmc/libdvdcss/archive/${LIBDVDCSS_COMMIT}.tar.gz -> libdvdcss-${LIBDVDCSS_COMMIT}.tar.gz
	https://github.com/xbmc/libdvdread/archive/${LIBDVDREAD_COMMIT}.tar.gz -> libdvdread-${LIBDVDREAD_COMMIT}.tar.gz
	https://github.com/xbmc/libdvdnav/archive/${LIBDVDNAV_COMMIT}.tar.gz -> libdvdnav-${LIBDVDNAV_COMMIT}.tar.gz
	!system-ffmpeg? ( https://github.com/xbmc/FFmpeg/archive/${FFMPEG_VERSION}-${CODENAME}.tar.gz -> ffmpeg-${PN}-${FFMPEG_VERSION}-${CODENAME}.tar.gz )"

DESCRIPTION="Kodi is a free and open source media-player and entertainment hub"
HOMEPAGE="https://kodi.tv/ http://kodi.wiki/"

LICENSE="GPL-2"
SLOT="0"
# use flag is called libusb so that it doesn't fool people in thinking that
# it is _required_ for USB support. Otherwise they'll disable udev and
# that's going to be worse.
IUSE="airplay alsa bluetooth bluray caps cec +css dbus debug dvd gles libressl libusb lirc mysql nfs nonfree +opengl +ssl pulseaudio samba sftp systemd +system-ffmpeg test +udev udisks upnp upower vaapi vdpau webserver +X +xslt zeroconf"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( gles opengl )
	udev? ( !libusb )
	udisks? ( dbus )
	upower? ( dbus )
"

COMMON_DEPEND="${PYTHON_DEPS}
	airplay? (
		app-pda/libplist
		net-libs/shairplay
	)
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	bluray? ( >=media-libs/libbluray-0.7.0 )
	caps? ( sys-libs/libcap )
	dbus? ( sys-apps/dbus )
	dev-db/sqlite
	dev-libs/expat
	dev-libs/fribidi
	cec? ( >=dev-libs/libcec-4.0 )
	dev-libs/libpcre[cxx]
	dev-libs/libxml2
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	>=dev-libs/yajl-2
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-libs/libcdio
	gles? ( media-libs/mesa[gles2] )
	libusb? ( virtual/libusb:1 )
	media-fonts/corefonts
	>=media-fonts/noto-20160531
	media-fonts/roboto
	media-libs/fontconfig
	media-libs/freetype
	>=media-libs/libass-0.13.4
	media-libs/mesa[egl]
	>=media-libs/taglib-1.11.1
	system-ffmpeg? ( >=media-video/ffmpeg-${FFMPEG_VERSION}:=[encode,postproc] )
	mysql? ( virtual/mysql )
	>=net-misc/curl-7.51.0
	nfs? ( net-fs/libnfs:= )
	opengl? ( media-libs/glu )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.2j:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( >=net-fs/samba-3.4.6[smbclient(+)] )
	sftp? ( net-libs/libssh[sftp] )
	sys-libs/zlib
	udev? ( virtual/udev )
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( >=x11-libs/libvdpau-1.1 >=x11-drivers/nvidia-drivers-180.51 )
		media-video/ffmpeg[vdpau]
	)
	webserver? ( >=net-libs/libmicrohttpd-0.9.50[messages] )
	X? (
		x11-libs/libdrm
		x11-libs/libX11
		x11-libs/libXrandr
		x11-libs/libXrender
	)
	xslt? ( dev-libs/libxslt )
	zeroconf? ( net-dns/avahi[dbus] )
"
RDEPEND="${COMMON_DEPEND}
	lirc? (
		|| ( app-misc/lirc app-misc/inputlircd )
	)
	!media-tv/xbmc
	udisks? ( sys-fs/udisks:0 )
	upower? (
		systemd? ( sys-power/upower )
		!systemd? (
			|| ( sys-power/upower-pm-utils sys-power/upower )
		)
	)
"
DEPEND="${COMMON_DEPEND}
	app-arch/bzip2
	app-arch/unzip
	app-arch/xz-utils
	app-arch/zip
	dev-lang/swig
	dev-libs/crossguid
	dev-util/cmake
	dev-util/gperf
	media-libs/giflib
	>=media-libs/libjpeg-turbo-1.5.1:=
	>=media-libs/libpng-1.6.26:0=
	test? ( dev-cpp/gtest )
	virtual/pkgconfig
	x86? ( dev-lang/nasm )
"
case ${PV} in
9999)
	EGIT_REPO_URI="git://github.com/xbmc/xbmc.git"
	inherit git-r3
	# Force java for latest git version to avoid having to hand maintain the
	# generated addons package.  #488118
	DEPEND+="
		virtual/jre
		"
	;;
*)
	MY_PV=${PV/_p/_r}
	MY_PV=${MY_PV/_alpha/a}
	MY_PV=${MY_PV/_beta/b}
	MY_PV=${MY_PV/_rc/rc}
	MY_P="${PN}-${MY_PV}"
	SRC_URI+=" https://github.com/xbmc/xbmc/archive/${MY_PV}-${CODENAME}.tar.gz -> ${MY_P}.tar.gz
		 !java? ( https://github.com/candrews/gentoo-kodi/raw/master/${MY_P}-generated-addons.tar.xz )"
	KEYWORDS="~amd64 ~x86"
	IUSE+=" java"
	DEPEND+="
		java? ( virtual/jre )
		"

	S=${WORKDIR}/xbmc-${MY_PV}-${CODENAME}
	;;
esac

CONFIG_CHECK="~IP_MULTICAST"
ERROR_IP_MULTICAST="
In some cases Kodi needs to access multicast addresses.
Please consider enabling IP_MULTICAST under Networking options.
"

pkg_setup() {
	check_extra_config
	python-single-r1_pkg_setup
}

src_prepare() {
	if in_iuse java && use !java; then
		eapply "${FILESDIR}"/${PN}-cmake-no-java.patch
	fi
	cmake-utils_src_prepare

	# avoid long delays when powerkit isn't running #348580
	sed -i \
		-e '/dbus_connection_send_with_reply_and_block/s:-1:3000:' \
		xbmc/linux/*.cpp || die

	# Prepare tools and libs witch are configured with autotools during compile time
	AUTOTOOLS_DIRS=(
		"${S}"/lib/cpluff
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
		"${S}"/cmake/modules/FindCpluff.cmake \
		"${S}"/tools/depends/native/TexturePacker/src/autogen.sh \
		"${S}"/tools/depends/native/JsonSchemaBuilder/src/autogen.sh
}

src_configure() {
	local CMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo)

	local mycmakeargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_LDGOLD=OFF # https://bugs.gentoo.org/show_bug.cgi?id=606124
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AIRTUNES=$(usex airplay)
		-DENABLE_AVAHI=$(usex zeroconf)
		-DENABLE_BLUETOOTH=$(usex bluetooth)
		-DENABLE_BLURAY=$(usex bluray)
		-DENABLE_CCACHE=OFF
		-DENABLE_CEC=$(usex cec)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_DVDCSS=$(usex css)
		-DENABLE_INTERNAL_CROSSGUID=OFF
		-DENABLE_INTERNAL_FFMPEG="$(usex !system-ffmpeg)"
		-DENABLE_CAP=$(usex caps)
		-DENABLE_LIRC=$(usex lirc)
		-DENABLE_MICROHTTPD=$(usex webserver)
		-DENABLE_MYSQLCLIENT=$(usex mysql)
		-DENABLE_NFS=$(usex nfs)
		-DENABLE_NONFREE=$(usex nonfree)
		-DENABLE_OPENGLES=$(usex gles)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_OPENSSL=$(usex ssl)
		-DENABLE_OPTICAL=$(usex dvd)
		-DENABLE_PLIST=$(usex airplay)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_SMBCLIENT=$(usex samba)
		-DENABLE_SSH=$(usex sftp)
		-DENABLE_UDEV=$(usex udev)
		-DENABLE_UPNP=$(usex upnp)
		-DENABLE_VAAPI=$(usex vaapi)
		-DENABLE_VDPAU=$(usex vdpau)
		-DENABLE_X11=$(usex X)
		-DENABLE_XSLT=$(usex xslt)
		-Dlibdvdread_URL="${DISTDIR}/libdvdread-${LIBDVDREAD_COMMIT}.tar.gz"
		-Dlibdvdnav_URL="${DISTDIR}/libdvdnav-${LIBDVDNAV_COMMIT}.tar.gz"
		-Dlibdvdcss_URL="${DISTDIR}/libdvdcss-${LIBDVDCSS_COMMIT}.tar.gz"
	)

	use libusb && mycmakeargs+=( -DENABLE_LIBUSB=$(usex libusb) )

	use !system-ffmpeg && mycmakeargs+=( -DFFMPEG_URL="${DISTDIR}/ffmpeg-${PN}-${FFMPEG_VERSION}-${CODENAME}.tar.gz" )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usev test)
}

src_install() {
	cmake-utils_src_install
	rm "${ED%/}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}* || die

	newicon media/icon48x48.png kodi.png

	# Replace bundled fonts with system ones.
	rm "${ED%/}"/usr/share/kodi/addons/skin.estouchy/fonts/NotoSans-Regular.ttf || die
	dosym /usr/share/fonts/noto/NotoSans-Regular.ttf \
		usr/share/kodi/addons/skin.estouchy/fonts/NotoSans-Regular.ttf

	local f
	for f in NotoMono-Regular.ttf NotoSans-Bold.ttf NotoSans-Regular.ttf ; do
		rm "${ED%/}"/usr/share/kodi/addons/skin.estuary/fonts/"${f}" || die
		dosym /usr/share/fonts/noto/"${f}" \
			usr/share/kodi/addons/skin.estuary/fonts/"${f}"
	done

	rm "${ED%/}"/usr/share/kodi/addons/skin.estuary/fonts/Roboto-Thin.ttf || die
	dosym /usr/share/fonts/roboto/Roboto-Thin.ttf \
		usr/share/kodi/addons/skin.estuary/fonts/Roboto-Thin.ttf

	python_domodule tools/EventClients/lib/python/xbmcclient.py
	python_newscript "tools/EventClients/Clients/Kodi Send/kodi-send.py" kodi-send
}
