# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )

inherit flag-o-matic linux-info python-single-r1 systemd toolchain-funcs

# We need to re-host the pre-built assets tarball because it's hidden behind a
# download API. It's smaller than the npm cache needed to rebuild them.
# When bumping, run this, and update WEBUI_VUE_HASH below.
# EXTRA_ECONF="--enable-vue_cache --disable-vue_build" ebuild tvheadend-9999.ebuild clean compile
# cp -v /var/tmp/portage/media-tv/tvheadend-9999/work/tvheadend-9999/build.linux/webui-vue-*.tgz /var/cache/distfiles/

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	COMMIT=""
	WEBUI_VUE_HASH=""
	SRC_URI="https://github.com/tvheadend/tvheadend/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~chewi/distfiles/webui-vue-${WEBUI_VUE_HASH}.tgz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	export TVHEADEND_FILE_CACHE="${DISTDIR}"
fi

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus debug +ddci dvbcsa +dvb +ffmpeg hdhomerun +imagecache +inotify iptv opus satip systemd +timeshift uriparser vaapi vpx x264 x265 xmltv zeroconf zlib"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ddci? ( dvb )
	vaapi? ( ffmpeg )
"

BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	virtual/pkgconfig
"

RDEPEND="
	${PYTHON_DEPS}
	acct-user/tvheadend
	virtual/libiconv
	dbus? ( sys-apps/dbus )
	dvbcsa? ( media-libs/libdvbcsa )
	ffmpeg? ( =media-video/ffmpeg-8.1*:=[opus?,vpx?,x264?,x265?] )
	hdhomerun? ( media-libs/libhdhomerun )
	dev-libs/openssl:0=
	uriparser? ( dev-libs/uriparser )
	zeroconf? ( net-dns/avahi )
	zlib? ( virtual/zlib:= )
"

# ffmpeg sub-dependencies needed for headers only. Check under
# src/transcoding/codec/codecs/libs for include statements.

DEPEND="
	${RDEPEND}
	dvb? ( sys-kernel/linux-headers )
	ffmpeg? (
		opus? ( media-libs/opus )
		vpx? ( media-libs/libvpx )
		x264? ( media-libs/x264 )
		x265? ( media-libs/x265 )
	)
	vaapi? ( media-libs/libva:= )
"

RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_USEDEP}]
	')
	dvb? ( media-tv/dtv-scan-tables )
	xmltv? ( media-tv/xmltv )
"

[[ ${PV} == *9999* ]] && BDEPEND+="
	net-libs/nodejs[npm]
"

# Some patches from:
# https://github.com/rpmfusion/tvheadend

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.9-use_system_queue.patch
	"${FILESDIR}"/${PN}-4.3-hdhomerun.patch
	"${FILESDIR}"/${PN}-4.2.2-dtv_scan_tables.patch
	"${FILESDIR}"/${PN}-4.2.7-python3.patch
	"${FILESDIR}"/${PN}-4.3-ffmpeg9.patch
)

DOCS=( README.md )

# Make npm behave.
export npm_config_audit=false
export npm_config_color=false
export npm_config_foreground_scripts=true
export npm_config_loglevel=verbose
export npm_config_optional=true
export npm_config_progress=false
export npm_config_save=false

pkg_setup() {
	python-single-r1_pkg_setup

	use inotify &&
		CONFIG_CHECK="~INOTIFY_USER" linux-info_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		# This downloads things so must go in src_unpack to avoid the sandbox.
		env -C "${S}"/src/webui/static-vue npm install || die
	else
		unpack ${P}.tar.gz
	fi
}

# We unconditionally enable codecs that do not require additional
# dependencies when building tvheadend. If support is missing from
# ffmpeg at runtime then tvheadend will simply disable these codecs.

# It is not necessary to specific all the --disable-*-static options as
# most of them only take effect when --enable-ffmpeg_static is given.

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/932794
	# https://github.com/tvheadend/tvheadend/issues/1732
	filter-lto

	local myconf=(
		--disable-bundle
		--disable-ccache
		--disable-dvbscan
		--disable-ffmpeg_static
		--disable-hdhomerun_static
		--enable-libfdkaac
		--enable-libtheora
		--enable-libvorbis
		--nowerror
		$(use_enable dbus dbus_1)
		$(use_enable debug trace)
		$(use_enable ddci)
		$(use_enable dvb linuxdvb)
		$(use_enable dvbcsa)
		$(use_enable dvbcsa capmt)
		$(use_enable dvbcsa cccam)
		$(use_enable dvbcsa constcw)
		$(use_enable dvbcsa cwc)
		$(use_enable ffmpeg libav)
		$(use_enable hdhomerun hdhomerun_client)
		$(use_enable imagecache)
		$(use_enable inotify)
		$(use_enable iptv)
		$(use_enable opus libopus)
		$(use_enable satip satip_server)
		$(use_enable satip satip_client)
		$(use_enable systemd libsystemd_daemon)
		$(use_enable timeshift)
		$(use_enable uriparser)
		$(use_enable vaapi)
		$(use_enable vpx libvpx)
		$(use_enable x264 libx264)
		$(use_enable x265 libx265)
		$(use_enable zeroconf avahi)
		$(use_enable zlib)
	)

	# For live, we build the assets, but for non-live, we just use pre-built
	# assets. If you want to modify the assets, use the live ebuild.
	if [[ ${PV} == *9999* ]]; then
		myconf+=(
			--disable-vue_cache
			--enable-vue_build
		)
	else
		myconf+=(
			--enable-vue_cache
			--disable-vue_build
		)
	fi

	CC="$(tc-getCC)" \
	PKG_CONFIG="$(tc-getPKG_CONFIG)" \
	npm_config_offline=1 \
	econf "${myconf[@]}"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	python_fix_shebang "${ED}"/usr/bin/

	newinitd "${FILESDIR}"/tvheadend.initd tvheadend
	newconfd "${FILESDIR}"/tvheadend.confd tvheadend

	use systemd &&
		systemd_dounit "${FILESDIR}"/tvheadend.service
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."

	. "${EROOT}"/etc/conf.d/tvheadend &>/dev/null

	if [[ ${TVHEADEND_CONFIG} = ${EPREFIX}/etc/tvheadend ]]; then
		echo
		ewarn "The HOME directory for the tvheadend user has changed from"
		ewarn "${EPREFIX}/etc/tvheadend to ${EPREFIX}/var/lib/tvheadend. The daemon will continue"
		ewarn "to use the old location until you update TVHEADEND_CONFIG in"
		ewarn "${EPREFIX}/etc/conf.d/tvheadend. Please manually move your existing files"
		ewarn "before you do so."
	fi
}
