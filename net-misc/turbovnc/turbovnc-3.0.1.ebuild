# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop java-pkg-opt-2

DESCRIPTION="A fast replacement for TigerVNC"
HOMEPAGE="https://www.turbovnc.org/"
SRC_URI="https://sourceforge.net/projects/turbovnc/files/${PV}/${P}.tar.gz/download -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ssl"

COMMON_DEPEND="
	app-arch/bzip2
	media-libs/freetype
	>=media-libs/libjpeg-turbo-2.0.0:=[java?]
	sys-libs/pam
	sys-libs/zlib
	virtual/opengl
	x11-apps/xauth
	x11-libs/libfontenc
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfont2
	x11-libs/libxkbfile
	x11-libs/pixman
	x11-misc/xkeyboard-config
	java? (
		>=virtual/jdk-1.8:*
		x11-libs/libXi
		!net-misc/tigervnc
	)
	ssl? ( dev-libs/openssl:= )
	!net-misc/tigervnc[server]
"
RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xkbcomp
"
DEPEND="
	${COMMON_DEPEND}
	x11-libs/xtrans
"

PATCHES=( "${FILESDIR}"/"${PN}"-3.0-fix-musl-compilation.patch )

src_prepare() {
	use java && java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTVNC_SYSTEMX11=ON
		-DTVNC_SYSTEMLIBS=ON
		-DTVNC_BUILDVIEWER=$(usex java)
		-DTVNC_BUILDHELPER=$(usex java)
		-DXKB_BIN_DIRECTORY=/usr/bin
		-DXKB_DFLT_RULES=base
	)

	if use ssl ; then
		# Link properly against OpenSSL to ensure
		# we catch e.g. ABI change
		# (i.e. don't dlopen it)
		mycmakeargs+=(
			-DTVNC_USETLS=OpenSSL
			-DTVNC_DLOPENSSL=OFF
		)
	else
		mycmakeargs+=( -DTVNC_USETLS=OFF )
	fi

	if use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use java ; then
		java-pkg_dojar "${BUILD_DIR}"/java/VncViewer.jar
		make_desktop_entry vncviewer "TurboVNC Viewer" /usr/share/icons/hicolor/48x48/apps/${PN}.png
	fi

	# Don't install incompatible init script
	rm -rf "${ED}"/etc/init.d/ || die
	rm -rf "${ED}"/etc/sysconfig/ || die

	find "${ED}"/usr/share/man/man1/ -name Xserver.1\* -delete || die

	einstalldocs
}
