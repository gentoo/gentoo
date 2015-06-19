# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rstudio/rstudio-0.97.551.ebuild,v 1.3 2015/02/28 04:39:43 gienah Exp $

EAPI=5

inherit eutils user cmake-utils gnome2-utils pam versionator fdo-mime java-pkg-2 pax-utils

# TODO
# * package gin and gwt
# * use dict from tree, linguas
# * do src_test (use junit from tree?)
# * fix the about/help/menu and get rid of license

GWTVER=2.5.0.rc1
GINVER=1.5

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org"
SRC_URI="https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://s3.amazonaws.com/rstudio-buildtools/gin-${GINVER}.zip
	https://s3.amazonaws.com/rstudio-buildtools/gwt-${GWTVER}.zip
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dedicated server"

QTVER=4.8
QTSLOT=4
RDEPEND=">=dev-lang/R-2.11.1
	>=dev-libs/boost-1.50:=
	dev-libs/mathjax
	dev-libs/openssl:0
	>=virtual/jre-1.5:=
	x11-libs/pango
	!dedicated? (
		>=dev-qt/qtcore-${QTVER}:${QTSLOT}
		>=dev-qt/qtdbus-${QTVER}:${QTSLOT}
		>=dev-qt/qtgui-${QTVER}:${QTSLOT}
		>=dev-qt/qtwebkit-${QTVER}:${QTSLOT}
		>=dev-qt/qtxmlpatterns-${QTVER}:${QTSLOT}
		server? ( virtual/pam )
	)
	dedicated? ( virtual/pam )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.5
	virtual/pkgconfig"
#	test? ( dev-java/junit:4 )

src_unpack() {
	unpack ${P}.tar.gz gwt-${GWTVER}.zip
	cd "${S}" || die
	mkdir -p src/gwt/lib/{gin,gwt} dependencies/common/dictionaries || die
	mv ../gwt-${GWTVER} src/gwt/lib/gwt/${GWTVER} || die
	unzip -qd src/gwt/lib/gin/${GINVER} "${DISTDIR}"/gin-${GINVER}.zip || die
	unzip -qd dependencies/common/dictionaries "${DISTDIR}"/core-dictionaries.zip || die
}

src_prepare() {
	java-pkg-2_src_prepare

	find . -name .gitignore -delete || die

	epatch "${FILESDIR}"/${P}-prefs.patch \
		"${FILESDIR}"/${P}-paths.patch \
		"${FILESDIR}"/${P}-linker_flags.patch \
		"${FILESDIR}"/${P}-boost-1.53.patch

	# Adding -DDISTRO_SHARE=... to append-flags breaks cmake so using
	# this sed hack for now. ~RMH
	sed -i \
		-e "s|DISTRO_SHARE|\"share/${PN}\"|g" \
		src/cpp/server/ServerOptions.cpp \
		src/cpp/session/SessionOptions.cpp || die

	# use mathjax from system
	ln -sf "${EPREFIX}"/usr/share/mathjax dependencies/common/mathjax || die

	# make sure icons and mime stuff are with prefix
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		CMakeGlobals.txt src/cpp/desktop/CMakeLists.txt || die

	# specify that namespace core the is in the global namespace and not
	# relative to some other namespace (like its ::core not ::boost::core)
	find . \( -name *.cpp -or -name *.hpp \) -exec sed \
		-e 's@<core::@< ::core::@g' -e 's@\([^:]\)core::@\1::core::@g' -i {} \;
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(get_version_component_range 1)
	export RSTUDIO_VERSION_MINOR=$(get_version_component_range 2)
	export RSTUDIO_VERSION_PATCH=$(get_version_component_range 3)

	local mycmakeargs=(
		-DDISTRO_SHARE=share/${PN}
		$(cmake-utils_use !dedicated RSTUDIO_INSTALL_FREEDESKTOP)
		-DRSTUDIO_TARGET=$(usex dedicated "Server" "$(usex server "All" "Desktop")")
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	pax-mark m "${ED}usr/bin/rstudio"
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
