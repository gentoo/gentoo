# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Does not work with py3 here
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils linux-info python-single-r1 multiprocessing autotools toolchain-funcs

LIBDVDCSS_COMMIT="2f12236bc1c92f73c21e973363f79eb300de603f"
LIBDVDREAD_COMMIT="17d99db97e7b8f23077b342369d3c22a6250affd"
LIBDVDNAV_COMMIT="43b5f81f5fe30bceae3b7cecf2b0ca57fc930dac"
CODENAME="Krypton"
case ${PV} in
9999)
	EGIT_REPO_URI="git://github.com/xbmc/xbmc.git"
	inherit git-r3
	;;
*)
	MY_PV=${PV/_p/_r}
	MY_PV=${MY_PV//_alpha/a}
	MY_PV=${MY_PV//_beta/b}
	MY_PV=${MY_PV//_rc/rc}
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/xbmc/xbmc/archive/${MY_PV}-${CODENAME}.tar.gz -> ${MY_P}.tar.gz
		https://github.com/xbmc/libdvdcss/archive/${LIBDVDCSS_COMMIT}.tar.gz -> libdvdcss-${LIBDVDCSS_COMMIT}.tar.gz
		https://github.com/xbmc/libdvdread/archive/${LIBDVDREAD_COMMIT}.tar.gz -> libdvdread-${LIBDVDREAD_COMMIT}.tar.gz
		https://github.com/xbmc/libdvdnav/archive/${LIBDVDNAV_COMMIT}.tar.gz -> libdvdnav-${LIBDVDNAV_COMMIT}.tar.gz
		!java? ( https://github.com/candrews/gentoo-kodi/raw/master/${MY_P}-generated-addons.tar.xz )"
	KEYWORDS="~amd64 ~x86"

	S=${WORKDIR}/xbmc-${MY_PV}-${CODENAME}
	;;
esac

DESCRIPTION="Kodi is a free and open source media-player and entertainment hub"
HOMEPAGE="https://kodi.tv/ http://kodi.wiki/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa bluetooth bluray caps cec dbus debug gles java midi mysql nfs +opengl profile pulseaudio +samba sftp test +texturepacker udisks upnp upower +usb vaapi vdpau webserver +X zeroconf"
# gles/vaapi: http://trac.kodi.tv/ticket/10552 #464306
REQUIRED_USE="
	|| ( gles opengl )
	?? ( gles vaapi )
	udisks? ( dbus )
	upower? ( dbus )
"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-i18n/enca
	airplay? ( app-pda/libplist )
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	cec? ( >=dev-libs/libcec-3.0 )
	dev-libs/libpcre[cxx]
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	>=dev-libs/yajl-2
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-fonts/anonymous-pro
	media-fonts/corefonts
	media-fonts/dejavu
	alsa? ( media-libs/alsa-lib )
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/jasper:=
	media-libs/jbigkit
	>=media-libs/libass-0.9.7
	bluray? ( >=media-libs/libbluray-0.7.0 )
	media-libs/libmad
	media-libs/libmodplug
	media-libs/libmpeg2
	media-libs/libsamplerate
	>=media-libs/taglib-1.9
	media-libs/tiff:0=
	media-sound/wavpack
	>=media-video/ffmpeg-3.0:=[encode]
	nfs? ( net-fs/libnfs:= )
	webserver? ( net-libs/libmicrohttpd[messages] )
	sftp? ( net-libs/libssh[sftp] )
	net-misc/curl
	samba? ( >=net-fs/samba-3.4.6[smbclient(+)] )
	bluetooth? ( net-wireless/bluez )
	dbus? ( sys-apps/dbus )
	caps? ( sys-libs/libcap )
	sys-libs/zlib
	virtual/jpeg:0=
	usb? ( virtual/libusb:1 )
	mysql? ( virtual/mysql )
	opengl? (
		virtual/glu
		virtual/opengl
		>=media-libs/glew-1.5.6:=
	)
	gles? (
		media-libs/mesa[gles2]
	)
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( >=x11-libs/libvdpau-1.1 >=x11-drivers/nvidia-drivers-180.51 )
		media-video/ffmpeg[vdpau]
	)
	X? (
		x11-apps/xdpyinfo
		x11-apps/mesa-progs
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
	)
	zeroconf? ( net-dns/avahi )
"
RDEPEND="${COMMON_DEPEND}
	!media-tv/xbmc
	udisks? ( sys-fs/udisks:0 )
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/swig
	dev-libs/crossguid
	dev-util/gperf
	texturepacker? ( media-libs/giflib )
	X? ( x11-proto/xineramaproto )
	dev-util/cmake
	x86? ( dev-lang/nasm )
	java? ( virtual/jre )
	test? ( dev-cpp/gtest )
	virtual/pkgconfig"
# Force java for latest git version to avoid having to hand maintain the
# generated addons package.  #488118
[[ ${PV} == "9999" ]] && DEPEND+=" virtual/jre"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-no-arm-flags.patch #400618887
	"${FILESDIR}"/${PN}-9999-texturepacker.patch
)

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
	[[ ${PV} == "9999" ]] && git-r3_src_unpack || default
	cp "${DISTDIR}/libdvdcss-${LIBDVDCSS_COMMIT}.tar.gz" "${S}/tools/depends/target/libdvdcss/libdvdcss-master.tar.gz" || die
	cp "${DISTDIR}/libdvdread-${LIBDVDREAD_COMMIT}.tar.gz" "${S}/tools/depends/target/libdvdread/libdvdread-master.tar.gz" || die
	cp "${DISTDIR}/libdvdnav-${LIBDVDNAV_COMMIT}.tar.gz" "${S}/tools/depends/target/libdvdnav/libdvdnav-master.tar.gz" || die
}

src_prepare() {
	default

	# some dirs ship generated autotools, some dont
	multijob_init
	local d dirs=(
		tools/depends/native/TexturePacker/src/configure
		$(printf 'f:\n\t@echo $(BOOTSTRAP_TARGETS)\ninclude bootstrap.mk\n' | emake -f - f)
	)
	for d in "${dirs[@]}" ; do
		[[ -e ${d} ]] && continue
		pushd ${d/%configure/.} >/dev/null || die
		AT_NOELIBTOOLIZE="yes" AT_TOPLEVEL_EAUTORECONF="yes" \
		multijob_child_init eautoreconf
		popd >/dev/null || die
	done
	multijob_finish
	elibtoolize

	# Cross-compiler support
	# We need JsonSchemaBuilder and TexturePacker binaries for the host system
	# Later we need libsquish for the target system
	if tc-is-cross-compiler ; then
		mkdir "${WORKDIR}"/${CBUILD} || die
		pushd "${WORKDIR}"/${CBUILD} >/dev/null || die
		einfo "Building host tools"
		cp -a "$S"/{tools,xbmc} ./ || die
		local tools=( JsonSchemaBuilder )
		use texturepacker && tools+=( TexturePacker )
		for tool in "${tools[@]}" ; do
			tc-env_build emake -C tools/depends/native/$tool
			mkdir "$S"/tools/depends/native/$tool/bin || die
			ln -s "${WORKDIR}"/${CBUILD}/tools/depends/native/$tool/bin/$tool "$S"/tools/depends/native/$tool/bin/$tool || die
		done
		popd >/dev/null || die

		emake -f codegenerator.mk

		# Binary kodi.bin links against libsquish,
		# so we need libsquish compiled for the target system
		emake -C tools/depends/native/libsquish-native/ CXX=$(tc-getCXX)
	elif [[ ${PV} == "9999" ]] || use java ; then #558798
		tc-env_build emake -f codegenerator.mk
	fi

	# Disable internal func checks as our USE/DEPEND
	# stuff handles this just fine already #408395
	export ac_cv_lib_avcodec_ff_vdpau_vc1_decode_picture=yes

	# Fix the final version string showing as "exported"
	# instead of the SVN revision number.
	export HAVE_GIT=no GIT_REV=${EGIT_VERSION:-exported}

	# avoid long delays when powerkit isn't running #348580
	sed -i \
		-e '/dbus_connection_send_with_reply_and_block/s:-1:3000:' \
		xbmc/linux/*.cpp || die

	# Tweak autotool timestamps to avoid regeneration
	find . -type f -exec touch -r configure {} + || die
}

src_configure() {
	# Disable documentation generation
	export ac_cv_path_LATEX=no
	# Avoid help2man
	export HELP2MAN=$(type -P help2man || echo true)
	# No configure flage for this #403561
	export ac_cv_lib_bluetooth_hci_devid=$(usex bluetooth)
	# Requiring java is asine #434662
	[[ ${PV} != "9999" ]] && export ac_cv_path_JAVA_EXE=$(which $(usex java java true))

	econf \
		--disable-ccache \
		--disable-optimizations \
		--with-ffmpeg=shared \
		$(use_enable alsa) \
		$(use_enable airplay) \
		$(use_enable bluray libbluray) \
		$(use_enable caps libcap) \
		$(use_enable cec libcec) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable gles) \
		$(use_enable midi mid) \
		$(use_enable mysql) \
		$(use_enable nfs) \
		$(use_enable opengl gl) \
		$(use_enable profile profiling) \
		$(use_enable pulseaudio pulse) \
		$(use_enable samba) \
		$(use_enable sftp ssh) \
		$(use_enable usb libusb) \
		$(use_enable test gtest) \
		$(use_enable texturepacker) \
		$(use_enable upnp) \
		$(use_enable vaapi) \
		$(use_enable vdpau) \
		$(use_enable webserver) \
		$(use_enable X x11) \
		$(use_enable zeroconf avahi)
}

src_compile() {
	emake V=1
}

src_install() {
	default
	rm "${ED%/}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}* || die

	domenu tools/Linux/kodi.desktop
	newicon media/icon48x48.png kodi.png

	# Remove fontconfig settings that are used only on MacOSX.
	# Can't be patched upstream because they just find all files and install
	# them into same structure like they have in git.
	rm -rf "${ED%/}"/usr/share/kodi/system/players/dvdplayer/etc || die

	# Replace bundled fonts with system ones.
	rm "${ED%/}"/usr/share/kodi/addons/skin.estouchy/fonts/DejaVuSans-Bold.ttf || die
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf \
		/usr/share/kodi/addons/skin.estouchy/fonts/DejaVuSans-Bold.ttf
	rm "${ED%/}"/usr/share/kodi/addons/skin.estuary/fonts/AnonymousPro.ttf || die
	dosym /usr/share/fonts/anonymous-pro/Anonymous\ Pro.ttf \
		/usr/share/kodi/addons/skin.estuary/fonts/AnonymousPro.ttf
	#lato is also present but cannot be unbundled because
	#lato isn't (yet) in portage: https://bugs.gentoo.org/show_bug.cgi?id=589288

	python_domodule tools/EventClients/lib/python/xbmcclient.py
	python_newscript "tools/EventClients/Clients/Kodi Send/kodi-send.py" kodi-send
}
