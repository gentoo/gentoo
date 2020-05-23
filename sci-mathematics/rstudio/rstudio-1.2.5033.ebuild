# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake-utils pam xdg-utils java-pkg-2 java-ant-2 pax-utils prefix qmake-utils vcs-clean

# TODO
# * use dict from tree, linguas
# * do src_test (use junit from tree?)

# update from scripts in dependencies/common
# egrep '(GWT_SDK_VER=|GIN_VER=)' dependencies/common/install-gwt
GWT_VER=2.8.1
GIN_VER=2.1.2
# grep 'PANDOC_VERSION=' dependencies/common/install-pandoc
# It should be PANDOC_VER=2.3.1 however >=app-text/pandoc-2.3.1 is not yet in portage
PANDOC_VER=1.19.2.1
# grep -5 QT_CANDIDATES src/cpp/desktop/CMakeLists.txt
QT_VER=5.10
QT_SLOT=5

DESCRIPTION="IDE for the R language"
HOMEPAGE="
	http://www.rstudio.org
	https://github.com/rstudio/rstudio/"
SRC_URI="
	https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dedicated libressl server"

RDEPEND="
	>=app-text/pandoc-${PANDOC_VER}
	dev-java/aopalliance:1
	dev-java/gin:2.1
	dev-java/gwt:2.8
	dev-java/javax-inject
	=dev-java/validation-api-1.0*:1.0[source]
	dev-haskell/pandoc-citeproc
	dev-lang/R
	dev-libs/boost:=
	>=dev-libs/mathjax-2.7.4
	sys-apps/util-linux
	sys-devel/clang:*
	sys-libs/zlib
	>=virtual/jre-1.8:=
	x11-libs/pango
	!dedicated? (
		>=dev-qt/qtcore-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtdeclarative-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtdbus-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtgui-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtnetwork-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtopengl-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtpositioning-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtprintsupport-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsingleapplication-2.6.1_p20150629[X,qt5(+)]
		>=dev-qt/qtsensors-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsql-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsvg-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwebchannel-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwebengine-${QT_VER}:${QT_SLOT}[widgets]
		>=dev-qt/qtwidgets-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxml-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxmlpatterns-${QT_VER}:${QT_SLOT}
		server? ( sys-libs/pam )
	)
	dedicated? ( sys-libs/pam )
	dedicated? (
		sys-libs/pam
		acct-user/rstudio-server
		acct-group/rstudio-server
	)
	server? (
		acct-user/rstudio-server
		acct-group/rstudio-server
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.8:=
	virtual/pkgconfig"
#	test? ( dev-java/junit:4 )

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.5033-prefs.patch
	"${FILESDIR}"/${PN}-1.2.5033-paths.patch
	"${FILESDIR}"/${PN}-1.2.5033-pandoc.patch
	"${FILESDIR}"/${PN}-1.2.1335-linker_flags.patch
	"${FILESDIR}"/${PN}-1.2.1335-qtsingleapplication.patch
	"${FILESDIR}"/${PN}-1.0.44-systemd.patch
	"${FILESDIR}"/${PN}-1.2.1335-core.patch
	"${FILESDIR}"/${PN}-1.2.1335-boost-1.70.0_p1.patch
	"${FILESDIR}"/${PN}-1.2.1335-boost-1.70.0_p2.patch
	"${FILESDIR}"/${PN}-1.2.5042-boost-1.73.0.patch
)

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}" || die
	mkdir -p dependencies/common/dictionaries
	unzip -qd dependencies/common/dictionaries \
		"${DISTDIR}"/core-dictionaries.zip || die
}

src_prepare() {
	cmake-utils_src_prepare
	java-pkg-2_src_prepare
	egit_clean

	# Enable CMake to install our .service file for systemd usage
	mkdir -vp "${S}/src/cpp/server/lib/systemd/system" || die
	cp -v "${FILESDIR}/rstudio-server.service.in" "${S}/src/cpp/server/lib/systemd/system/" || die

	# Adding -DDISTRO_SHARE=... to append-flags breaks cmake so using
	# this sed hack for now. ~RMH
	sed -i \
		-e "s|DISTRO_SHARE|\"share/${PN}\"|g" \
		src/cpp/server/ServerOptions.cpp \
		src/cpp/session/SessionOptions.cpp || die

	# use mathjax from system
	ln -sf "${EPREFIX}"/usr/share/mathjax dependencies/common/mathjax-26 || die

	# make sure icons and mime stuff are with prefix
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		CMakeGlobals.txt src/cpp/desktop/CMakeLists.txt || die

	# install themes in /etc/rstudio/extra/sthemes instead of /usr/extra/themes
	sed -i \
		-e "s@\(DESTINATION \"\)\(extras/themes\"\)@\1${EROOT}/etc/rstudio/\2@" \
		src/cpp/server/CMakeLists.txt || die

	# On Gentoo the rstudio-server configuration file is /etc/conf.d/rstudio-server.conf
	sed -e "s@/etc/rstudio/rserver.conf@${EROOT}/etc/conf.d/rstudio-server.conf@" \
		-i src/cpp/server/ServerOptions.cpp \
		|| die

	# Set the rsession.conf file location for Gentoo prefix
	sed -e "s@/etc/rstudio/rsession.conf@${EROOT}/etc/rstudio/rsession.conf@" \
		-i src/cpp/session/SessionOptions.cpp \
		|| die

	# dev-qt/qtsingleapplication-2.6.1_p20150629 does not provide a cmake module.
	# It provides a library that has its version number appended to the end,
	# which is difficult to handle in cmake, as find_library does not support
	# searching for wildcard library names. So I find the library name from the
	# qmake spec, and then sed this into the patched src/cpp/desktop/CMakeLists.txt.
	rm -rf "${S}"/src/cpp/desktop/3rdparty || die
	local s=$(grep '\-lQt$${QT_MAJOR_VERSION}Solutions_SingleApplication' \
				   $(qt5_get_mkspecsdir)/features/qtsingleapplication.prf \
					 | sed -e 's@\$\${QT_MAJOR_VERSION}@5@' \
						   -e 's@LIBS \*= -l@@')
	sed -e "s@Qt5Solutions_SingleApplication-2.6@${s}@g" \
		-i "${S}"/src/cpp/desktop/CMakeLists.txt \
		|| die

	# The git commit for tag: git rev-list -n 1 v${PV}
	sed -e 's@git ARGS rev-parse HEAD@echo ARGS 6871a99b32add885fe6fa3d50fe15f62346142e7@'\
		-i "${S}"/CMakeLists.txt \
		"${S}"/CMakeGlobals.txt \
		|| die

	eprefixify src/gwt/build.xml
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(ver_cut 1)
	export RSTUDIO_VERSION_MINOR=$(ver_cut 2)
	export RSTUDIO_VERSION_PATCH=$(ver_cut 3)

	local mycmakeargs=(
		-DDISTRO_SHARE=share/${PN}
		-DRSTUDIO_TARGET=$(usex dedicated "Server" "$(usex server "Development" "Desktop")")
		-DRSTUDIO_VERIFY_R_VERSION=FALSE
		)

	if use !dedicated; then
		mycmakeargs+=(
			-DRSTUDIO_INSTALL_FREEDESKTOP="$(usex !dedicated "ON" "OFF")"
			-DQT_QMAKE_EXECUTABLE=$(qt5_get_bindir)/qmake
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	local JAVA_ANT_REWRITE_CLASSPATH="yes"
	local EANT_BUILD_XML="src/gwt/build.xml"
	local EANT_BUILD_TARGET="clean"
	java-pkg-2_src_compile

	# Avoid the rest of the oracle-jdk-bin-1.8.0.60 sandbox violations F: mkdir S: deny
	# P: /root/.oracle_jre_usage.
	export ANT_OPTS="-Duser.home=${T}"
	cmake-utils_src_compile
}

src_install() {
	export ANT_OPTS="-Duser.home=${T}"
	cmake-utils_src_install
	use dedicated || pax-mark m "${ED}/usr/bin/rstudio"
	doconfd "${FILESDIR}"/rstudio-server.conf
	insinto /etc/rstudio
	doins "${FILESDIR}"/rsession.conf
	dosym ../conf.d/rstudio-server.conf /etc/rstudio/rserver.conf
	if use dedicated || use server; then
		dopamd src/cpp/server/extras/pam/rstudio
		newinitd "${FILESDIR}"/rstudio-server.initd rstudio-server
	fi
}

pkg_preinst() {
	java-pkg-2_pkg_preinst
}

pkg_postinst() {
	use dedicated || { xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update ;}
}

pkg_postrm() {
	use dedicated || { xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update ;}
}
