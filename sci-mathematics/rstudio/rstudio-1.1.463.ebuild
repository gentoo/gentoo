# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user cmake-utils gnome2-utils pam versionator xdg-utils java-pkg-2 pax-utils qmake-utils

# TODO
# * package gin and gwt
# * use dict from tree, linguas
# * do src_test (use junit from tree?)

# update from scripts in dependencies/common
# egrep '(GWT_SDK_VER=|GIN_VER=|SELENIUM_VER=|CHROMEDRIVER_VER=)' dependencies/common/install-gwt
GWT_VER=2.7.0
GIN_VER=1.5
SELENIUM_VER=2.37.0
CHROMEDRIVER_VER=2.7
# grep 'PANDOC_VERSION=' dependencies/common/install-pandoc
PANDOC_VER=1.19.2.1
# ls dependencies/common/*.tar.gz
PACKRAT_VER=0.98.1000
RMARKDOWN_VER=0.98.1000
SHINYAPPS_VER=0.98.1000
RSCONNECT_VER=0.4.1.4_fcac892a69817febd7b655b189bf57193260cda0

DESCRIPTION="IDE for the R language"
HOMEPAGE="
	http://www.rstudio.org
	https://github.com/rstudio/rstudio/"
SRC_URI="
	https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://s3.amazonaws.com/rstudio-buildtools/gin-${GIN_VER}.zip
	https://s3.amazonaws.com/rstudio-buildtools/gwt-${GWT_VER}.zip
	https://s3.amazonaws.com/rstudio-buildtools/selenium-java-${SELENIUM_VER}.zip
	https://s3.amazonaws.com/rstudio-buildtools/selenium-server-standalone-${SELENIUM_VER}.jar
	https://s3.amazonaws.com/rstudio-buildtools/chromedriver-linux
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip
	https://dev.gentoo.org/~gienah/distfiles/packrat-${PACKRAT_VER}.tar.gz
	https://dev.gentoo.org/~gienah/distfiles/rmarkdown-${RMARKDOWN_VER}.tar.gz
	https://dev.gentoo.org/~gienah/distfiles/shinyapps-${SHINYAPPS_VER}.tar.gz
	https://dev.gentoo.org/~gienah/distfiles/rsconnect_${RSCONNECT_VER}.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dedicated libressl server"

QT_VER=5.4
QT_SLOT=5
RDEPEND="
	>=app-text/pandoc-${PANDOC_VER}
	dev-haskell/pandoc-citeproc
	>=dev-lang/R-2.11.1
	<dev-libs/boost-1.70:=
	>=dev-libs/mathjax-2.7.4
	sys-apps/util-linux
	>=sys-devel/clang-3.5.0:*
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
		>=dev-qt/qtwebkit-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwidgets-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxml-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxmlpatterns-${QT_VER}:${QT_SLOT}
		server? ( virtual/pam )
	)
	dedicated? ( virtual/pam )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.8:=
	virtual/pkgconfig"
#	test? ( dev-java/junit:4 )

PATCHES=(
		"${FILESDIR}/${PN}-0.99.879-prefs.patch"
		"${FILESDIR}/${PN}-1.0.44-paths.patch"
		"${FILESDIR}/${PN}-1.1.357-clang-pandoc.patch"
		"${FILESDIR}/${PN}-0.98.490-linker_flags.patch"
		"${FILESDIR}/${PN}-0.99.473-qtsingleapplication.patch"
		"${FILESDIR}/${PN}-1.0.44-systemd.patch"
		"${FILESDIR}/${PN}-1.1.453-boost-1.67.0.patch"
		"${FILESDIR}/${PN}-1.1.453-core.patch"
		"${FILESDIR}/${PN}-1.1.463-boost-1.69.0_p1.patch"
		"${FILESDIR}/${PN}-1.1.463-boost-1.69.0_p2.patch"
		"${FILESDIR}/${PN}-1.1.463-fix-ptr-int-compare.patch"
)

src_unpack() {
	unpack ${P}.tar.gz gwt-${GWT_VER}.zip
	cd "${S}" || die
	mkdir -p src/gwt/lib/{gin,gwt} \
		dependencies/common/dictionaries \
		src/gwt/lib/selenium/${SELENIUM_VER} \
		src/gwt/lib/selenium/chromedriver/${CHROMEDRIVER_VER} || die
	mv ../gwt-${GWT_VER} src/gwt/lib/gwt/${GWT_VER} || die
	unzip -qd src/gwt/lib/gin/${GIN_VER} \
		"${DISTDIR}"/gin-${GIN_VER}.zip || die
	unzip -qd dependencies/common/dictionaries \
		"${DISTDIR}"/core-dictionaries.zip || die
	unzip -qd src/gwt/lib/selenium/${SELENIUM_VER} \
		"${DISTDIR}"/selenium-java-${SELENIUM_VER}.zip || die
	cp "${DISTDIR}"/selenium-server-standalone-${SELENIUM_VER}.jar \
		src/gwt/lib/selenium/${SELENIUM_VER}/ || die
	cp "${DISTDIR}"/chromedriver-linux \
		src/gwt/lib/selenium/chromedriver/${CHROMEDRIVER_VER}/ || die
	cd dependencies/common || die
	unpack packrat-${PACKRAT_VER}.tar.gz
	unpack rmarkdown-${RMARKDOWN_VER}.tar.gz
	unpack shinyapps-${SHINYAPPS_VER}.tar.gz
	unpack rsconnect_${RSCONNECT_VER}.tar.gz
	cp "${DISTDIR}"/rmarkdown-${RMARKDOWN_VER}.tar.gz \
		. || die
	cp "${DISTDIR}"/packrat-${PACKRAT_VER}.tar.gz \
		. || die
	cp "${DISTDIR}"/shinyapps-${SHINYAPPS_VER}.tar.gz \
		. || die
	cp "${DISTDIR}"/rsconnect_${RSCONNECT_VER}.tar.gz \
		. || die
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

	# On Gentoo the rstudio-server configuration file is /etc/conf.d/rstudio-server.conf
	sed -e "s@/etc/rstudio/rserver.conf@${EROOT}etc/conf.d/rstudio-server.conf@" \
		-i src/cpp/server/ServerOptions.cpp \
		|| die

	# Set the rsession.conf file location for Gentoo prefix
	sed -e "s@/etc/rstudio/rsession.conf@${EROOT}etc/rstudio/rsession.conf@" \
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
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(get_version_component_range 1)
	export RSTUDIO_VERSION_MINOR=$(get_version_component_range 2)
	export RSTUDIO_VERSION_PATCH=$(get_version_component_range 3)

	local mycmakeargs=(
		-DDISTRO_SHARE=share/${PN}
		-DRSTUDIO_INSTALL_FREEDESKTOP="$(usex !dedicated "ON" "OFF")"
		-DRSTUDIO_TARGET=$(usex dedicated "Server" "$(usex server "Development" "Desktop")")
		-DQT_QMAKE_EXECUTABLE=$(qt5_get_bindir)/qmake
		-DRSTUDIO_VERIFY_R_VERSION=FALSE
		)

	cmake-utils_src_configure
}

src_compile() {
	# Avoid the rest of the oracle-jdk-bin-1.8.0.60 sandbox violations F: mkdir S: deny
	# P: /root/.oracle_jre_usage.
	export ANT_OPTS="-Duser.home=${T}"
	cmake-utils_src_compile
}

src_install() {
	export ANT_OPTS="-Duser.home=${T}"
	cmake-utils_src_install
	pax-mark m "${ED}usr/bin/rstudio"
	doconfd "${FILESDIR}"/rstudio-server.conf
	dodir /etc/rstudio
	insinto /etc/rstudio
	doins "${FILESDIR}"/rsession.conf
	dosym "${ROOT}etc/conf.d/rstudio-server.conf" "${ROOT}etc/rstudio/rserver.conf"
	if use dedicated || use server; then
		dopamd src/cpp/server/extras/pam/rstudio
		newinitd "${FILESDIR}"/rstudio-server.initd rstudio-server
	fi
}

pkg_preinst() {
	use dedicated || gnome2_icon_savelist
	java-pkg-2_pkg_preinst
}

pkg_postinst() {
	use dedicated || { xdg_desktop_database_update
		xdg_mimeinfo_database_update
		gnome2_icon_cache_update ;}

	if use dedicated || use server; then
		enewgroup rstudio-server
		enewuser rstudio-server -1 -1 -1 rstudio-server
	fi
}

pkg_postrm() {
	use dedicated || { xdg_desktop_database_update
		xdg_mimeinfo_database_update
		gnome2_icon_cache_update ;}
}
