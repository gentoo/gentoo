# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_OPT_USE=viewer
inherit cmake desktop java-pkg-opt-2 optfeature verify-sig xdg

MY_PV="3.3beta2"

DESCRIPTION="A fast replacement for TigerVNC"
HOMEPAGE="https://www.turbovnc.org/"
SRC_URI="
	https://github.com/TurboVNC/turbovnc/releases/download/${MY_PV}/turbovnc-${PV%*_p1}.tar.gz -> ${P}.tar.gz
	verify-sig? ( https://github.com/TurboVNC/turbovnc/releases/download/${MY_PV}/turbovnc-${PV%*_p1}.tar.gz.sig ->
		${P}.tar.gz.sig )
"
S="${WORKDIR}"/${P%*_p1}

LICENSE="GPL-2"
SLOT="0"
IUSE="dri3 +server +ssl +viewer"
REQUIRED_USE="|| ( server viewer )"

COMMON_DEPEND="
	x11-apps/xauth
	x11-libs/libX11
	x11-libs/libXext
	x11-misc/xkeyboard-config
	server? (
		media-libs/libjpeg-turbo:=
		sys-libs/pam
		virtual/opengl
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXfont2
		x11-libs/pixman
		dri3? (
			media-libs/mesa[opengl]
			x11-libs/libxshmfence
		)
		ssl? ( dev-libs/openssl:= )
		!net-misc/tigervnc[server]
	)
	viewer? (
		media-libs/libjpeg-turbo:=[java]
		x11-libs/libXi
		!net-misc/tigervnc[viewer(+)]
	)
"

RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xkbcomp
	viewer? ( >=virtual/jre-17:* )
"

# libbz2.so.1, libfontenc.so.1 and libfreetype.so.6 are used by libXfont2.so.2
# but cmake will look for them, so add them here
DEPEND="
	${COMMON_DEPEND}
	media-libs/mesa
	x11-libs/xtrans
	viewer? ( >=virtual/jdk-17:* )
	server? (
		app-arch/bzip2
		media-libs/freetype
		x11-libs/libfontenc
	)
"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-vgl-turbovnc )
"

PATCHES=(
	"${FILESDIR}"/"${PN}"-3.0.90-fix-musl-compilation.patch
)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/vgl-turbovnc.asc

#879797 - BSD functions
QA_CONFIG_IMPL_DECL_SKIP=( strlcat strlcpy )

pkg_pretend() {
	if use ssl && ! use server; then
		einfo "USE=\"ssl\" selected but USE=\"server\" is not.  The SSL support is unused"
	fi
}

src_prepare() {
	use viewer && java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTVNC_BUILDVIEWER=$(usex viewer)
		-DTVNC_BUILDSERVER=$(usex server)
		-DTVNC_BUILDWEBSERVER=$(usex server)
	)

	if use server ; then
		mycmakeargs+=(
			-DTVNC_ZLIBNG=ON
			-DTVNC_DRI3=$(usex dri3)
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
	fi

	if use viewer ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	cmake_src_configure
}

src_compile() {
	# would need sys-libs/zlib-ng[compat] to unbundle this
	use server && cmake_build unix/Xvnc/lib/zlib-ng

	cmake_src_compile
}

src_install() {
	cmake_src_install

	if use viewer; then
		java-pkg_dojar "${BUILD_DIR}"/java/VncViewer.jar

		# replace upstream bash wrapper with the Gentoo one to choose the right javavm
		rm "${ED}"/usr/bin/vncviewer
		java-pkg_dolauncher vncviewer --jar VncViewer.jar \
			--java_args "-server -Djava.library.path=\"${EPREFIX}\"/usr/share/turbovnc/classes"

		make_desktop_entry vncviewer "TurboVNC Viewer" /usr/share/icons/hicolor/48x48/apps/${PN}.png
	fi

	# Don't install incompatible init script
	if use server; then
		rm -r "${ED}"/etc/init.d/ || die
		rm -r "${ED}"/etc/sysconfig/ || die
	fi

	# Conflicts with x11-base/xorg-server
	find "${ED}"/usr/share/man/man1/ -name Xserver.1\* -delete || die

	einstalldocs
}

pkg_postinst() {
	use server && optfeature "dbus support" sys-apps/dbus
}
