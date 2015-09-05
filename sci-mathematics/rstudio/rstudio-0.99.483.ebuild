# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user cmake-utils gnome2-utils pam versionator fdo-mime java-pkg-2 pax-utils

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
# grep 'PANDOC_VERSION=' dependencies/common/update-pandoc
PANDOC_VER=1.13.1
# ls dependencies/common/*.tar.gz
PACKRAT_VER=0.98.1000
RMARKDOWN_VER=0.98.1000
SHINYAPPS_VER=0.98.1000
RSCONNECT_VER=0.4.1.4_fcac892a69817febd7b655b189bf57193260cda0

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org
	https://github.com/rstudio/rstudio/"
SRC_URI="https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
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
IUSE="dedicated server"

QT_VER=5.4
QT_SLOT=5
RDEPEND="
	app-text/pandoc
	dev-haskell/pandoc-citeproc
	>=dev-lang/R-2.11.1
	>=dev-libs/boost-1.50:=
	>=dev-libs/mathjax-2.3
	dev-libs/openssl:0
	sys-apps/util-linux
	>=sys-devel/clang-3.5.0
	sys-libs/zlib
	|| ( =virtual/jre-1.7*:= =virtual/jre-1.8*:= )
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
		>=dev-qt/qtsingleapplication-2.6.1_p20150629[qt5]
		>=dev-qt/qtsensors-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsql-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtsvg-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwebkit-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtwidgets-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxml-${QT_VER}:${QT_SLOT}
		>=dev-qt/qtxmlpatterns-${QT_VER}:${QT_SLOT}
		server? ( virtual/pam )
	)
	dedicated? ( virtual/pam )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	|| ( =virtual/jdk-1.7*:= =virtual/jdk-1.8*:= )
	virtual/pkgconfig"
#	test? ( dev-java/junit:4 )

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
	java-pkg-2_src_prepare

	find . -name .gitignore -delete || die

	epatch "${FILESDIR}"/${PN}-0.98.490-prefs.patch \
		"${FILESDIR}"/${PN}-0.99.473-paths.patch \
		"${FILESDIR}"/${PN}-0.99.473-clang-pandoc.patch \
		"${FILESDIR}"/${PN}-0.98.490-linker_flags.patch \
		"${FILESDIR}"/${PN}-0.98.1091-boost-1.57.patch \
		"${FILESDIR}"/${PN}-0.99.473-qtsingleapplication.patch

	# Adding -DDISTRO_SHARE=... to append-flags breaks cmake so using
	# this sed hack for now. ~RMH
	sed -i \
		-e "s|DISTRO_SHARE|\"share/${PN}\"|g" \
		src/cpp/server/ServerOptions.cpp \
		src/cpp/session/SessionOptions.cpp || die

	# use mathjax from system
	ln -sf "${EPREFIX}"/usr/share/mathjax dependencies/common/mathjax-23 || die

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
				   "${EROOT}"/usr/lib64/qt5/mkspecs/features/qtsingleapplication.prf \
					 | sed -e 's@\$\${QT_MAJOR_VERSION}@5@' \
						   -e 's@LIBS \*= -l@@')
	sed -e "s@Qt5Solutions_SingleApplication-2.6@${s}@g" \
		-i "${S}"/src/cpp/desktop/CMakeLists.txt \
		|| die

	# Avoid some of the oracle-jdk-bin-1.8.0.60 sandbox violations F: mkdir S: deny
	# P: /root/.oracle_jre_usage.
	sed -e 's@\(\s*\)\(</classpath>\)@\1\2\n\1\<jvmarg value="-Duser.home=${env.T}"/>@g' \
		-i "${S}"/src/gwt/build.xml \
		|| die
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(get_version_component_range 1)
	export RSTUDIO_VERSION_MINOR=$(get_version_component_range 2)
	export RSTUDIO_VERSION_PATCH=$(get_version_component_range 3)

	local mycmakeargs=(
		-DDISTRO_SHARE=share/${PN}
		$(cmake-utils_use !dedicated RSTUDIO_INSTALL_FREEDESKTOP)
		-DRSTUDIO_TARGET=$(usex dedicated "Server" "$(usex server "Development" "Desktop")")
		-DQT_QMAKE_EXECUTABLE="${EROOT}"usr/lib64/qt5/bin/qmake
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
	dosym /etc/conf.d/rstudio-server.conf /etc/rstudio/rserver.conf
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
	use dedicated || { fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		gnome2_icon_cache_update ;}

	if use dedicated || use server; then
		enewgroup rstudio-server
		enewuser rstudio-server -1 -1 -1 rstudio-server
	fi
}

pkg_postrm() {
	use dedicated || { fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		gnome2_icon_cache_update ;}
}
