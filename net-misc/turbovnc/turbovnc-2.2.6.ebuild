# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop cmake java-pkg-opt-2

DESCRIPTION="A fast replacement for TigerVNC"
HOMEPAGE="https://www.turbovnc.org/"
SRC_URI="https://sourceforge.net/projects/turbovnc/files/${PV}/${P}.tar.gz/download -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=media-libs/libjpeg-turbo-2.0.0[java?]
	virtual/jdk:1.8
	!net-misc/tigervnc
"
RDEPEND="
	${DEPEND}
	x11-apps/xkbcomp
"

src_prepare() {
	use java && java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTVNC_SYSTEMX11=ON
		-DTVNC_SYSTEMLIBS=ON
		-DTVNC_BUILDJAVA=$(usex java)
		-DTVNC_BUILDNATIVE=ON
		-DXKB_BIN_DIRECTORY=/usr/bin
		-DXKB_DFLT_RULES=base
	)

	if use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"

		mycmakeargs+=(
			-DTJPEG_JAR="${EPREFIX}/usr/share/java/turbojpeg.jar"
			-DTJPEG_JNILIBRARY="${EPREFIX}/usr/$(get_libdir)/libturbojpeg.so"
		)
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

	find "${ED}/usr/share/man/man1/" -name Xserver.1\* -print0 | xargs -0 rm || die
	einstalldocs
}
