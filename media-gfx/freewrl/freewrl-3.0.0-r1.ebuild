# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools nsplugins eutils flag-o-matic java-pkg-opt-2 multilib

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.code.sf.net/p/freewrl/git"
	S="${WORKDIR}/${P}/freex3d"
	SRC_URI=
else
	SRC_URI="mirror://sourceforge/freewrl/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="VRML97 and X3D compliant browser, library, and web-browser plugin"
HOMEPAGE="http://freewrl.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
IUSE="curl debug java libeai motif +nsplugin opencl osc +sox static-libs"

COMMONDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm
	motif? ( x11-libs/motif:0= )
	!motif? ( x11-libs/libXaw )
	media-libs/mesa
	virtual/opengl
	media-libs/freealut
	media-libs/openal
	media-libs/libpng:0=
	virtual/jpeg:0=
	media-libs/imlib2
	>=media-libs/freetype-2
	media-libs/fontconfig
	curl? ( net-misc/curl )
	osc? ( media-libs/liblo )
	opencl? ( virtual/opencl )
	dev-lang/spidermonkey:0="
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.4 )
	nsplugin? ( net-misc/npapi-sdk )"
RDEPEND="${COMMONDEPEND}
	media-fonts/dejavu
	app-arch/unzip
	virtual/imagemagick-tools
	java? ( >=virtual/jre-1.4 )
	sox? ( media-sound/sox )"

src_prepare() {
	epatch_user
	epatch "${FILESDIR}"/${P}-fno-common.patch
	eautoreconf
}

src_configure() {
	# list of js libs without .pc support, to disable ./configure auto-checking
	local spidermonkeys=( mozilla-js xulrunner-js firefox-js firefox2-js seamonkey-js )
	# list of .pc supported spidermonkeys, to disable ./configure auto-checking
	local spidermonkeys_pc=( mozjs187 mozjs185 )

	local myconf="--enable-fontconfig
		--without-expat
		--with-x
		--with-imageconvert=/usr/bin/convert
		--with-unzip=/usr/bin/unzip
		--disable-mozjs-17.0
		${spidermonkeys[@]/#/ --disable-}"

	if has_version "<dev-lang/spidermonkey-1.8.5" ; then
		# spidermonkey pre-1.8.5 has no pkg-config, so override ./configure
		myconf+="${spidermonkeys_pc[@]/#/ --disable-}"
		JAVASCRIPT_ENGINE_CFLAGS="-I/usr/include/js -DXP_UNIX"
		if has_version ">=dev-lang/spidermonkey-1.8:0" ; then
			# spidermonkey-1.8 changed the name of the lib
			JAVASCRIPT_ENGINE_LIBS="-lmozjs"
		else
			JAVASCRIPT_ENGINE_LIBS="-ljs"
		fi
		if has_version "dev-lang/spidermonkey:0[threadsafe]" ; then
			JAVASCRIPT_ENGINE_CFLAGS+=" -DJS_THREADSAFE $(pkg-config --cflags nspr)"
			JAVASCRIPT_ENGINE_LIBS="$(pkg-config --libs nspr) ${JAVASCRIPT_ENGINE_LIBS}"
		fi
		export JAVASCRIPT_ENGINE_CFLAGS
		export JAVASCRIPT_ENGINE_LIBS
	fi
	if use nsplugin; then
		myconf+=" --with-plugindir=/usr/$(get_libdir)/${PLUGINS_DIR}"
		myconf+=" --disable-mozilla-plugin --disable-xulrunner-plugin"
	fi
	econf	${myconf} \
		$(use_enable curl libcurl) \
		$(use_with opencl OpenCL) \
		$(use_enable debug) $(use_enable debug thread_colorized) \
		$(use_enable libeai) \
		$(use_enable java) \
		$(use_enable nsplugin plugin) \
		$(use_enable osc) \
		$(use_enable static-libs static) \
		$(use_enable sox sound) \
		$(usex sox "--with-soundconv=/usr/bin/sox") \
		$(usex motif "--with-target=motif" "--with-target=x11") \
		$(usex motif "--with-statusbar=standard" "--with-statusbar=hud")
}

src_install() {
	emake DESTDIR="${D}" install

	if use java; then
		insinto /usr/share/${PN}/lib
		doins src/java/java.policy
		java-pkg_regjar src/java/vrml.jar
		# install vrml.jar as a JRE extension
		dodir /usr/java/packages/lib/ext
		dosym /usr/share/${PN}/lib/vrml.jar /usr/java/packages/lib/ext/vrml.jar
		if ! has_version "media-gfx/freewrl[java]" ; then
		elog "Because vrml.jar requires access to sockets, you will need to incorporate the"
		elog "contents of /usr/share/${PN}/lib/java.policy into your system or user's default"
		elog "java policy:"
		elog "	cat /usr/share/${PN}/lib/java.policy >>~/.java.policy"
		fi
	fi

	# remove unneeded .la files (as per Flameeyes' rant)
	cd "${D}"
	rm "usr/$(get_libdir)"/*.la "usr/$(get_libdir)/${PLUGINS_DIR}"/*.la
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
	elog "By default, FreeWRL expects to find the 'firefox' binary in your include"
	elog "path.  If you do not have firefox installed or you wish to use a different"
	elog "web browser to open links that are within VRML / X3D files, please be sure to"
	elog "specify the command via your BROWSER environment variable."
	fi
}
