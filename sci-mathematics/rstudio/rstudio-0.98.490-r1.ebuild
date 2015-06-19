# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rstudio/rstudio-0.98.490-r1.ebuild,v 1.5 2015/04/18 15:55:11 pacho Exp $

EAPI=5

inherit eutils cmake-utils gnome2-utils versionator fdo-mime java-pkg-2 pax-utils

# TODO
# * package gin and gwt
# * use dict from tree, linguas
# * do src_test (use junit from tree?)

GWTVER=2.5.1
GINVER=1.5

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org"
SRC_URI="https://github.com/rstudio/rstudio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://s3.amazonaws.com/rstudio-buildtools/gin-${GINVER}.zip
	https://s3.amazonaws.com/rstudio-buildtools/gwt-${GWTVER}.zip
	https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

QTVER=4.8
QTSLOT=4
RDEPEND=">=dev-lang/R-2.11.1
	>=dev-libs/boost-1.50:=
	dev-libs/mathjax
	dev-libs/openssl:0
	sys-libs/zlib
	>=virtual/jre-1.5:=
	x11-libs/pango
	>=dev-qt/qtcore-${QTVER}:${QTSLOT}
	>=dev-qt/qtdbus-${QTVER}:${QTSLOT}
	>=dev-qt/qtgui-${QTVER}:${QTSLOT}
	>=dev-qt/qtwebkit-${QTVER}:${QTSLOT}
	>=dev-qt/qtxmlpatterns-${QTVER}:${QTSLOT}"
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
		"${FILESDIR}"/${P}-linker_flags.patch

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
		-DRSTUDIO_INSTALL_FREEDESKTOP=ON
		-DRSTUDIO_TARGET=Desktop
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	pax-mark m "${ED}usr/bin/rstudio"
}

pkg_preinst() {
	gnome2_icon_savelist
	java-pkg-2_pkg_preinst
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
