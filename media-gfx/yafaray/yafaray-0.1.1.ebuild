# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/yafaray/yafaray-0.1.1.ebuild,v 1.6 2013/03/03 02:21:13 pesa Exp $

EAPI=2
MY_PN="YafaRay"

inherit multilib

DESCRIPTION="YafaRay is a raytracing open source render engine"
HOMEPAGE="http://www.yafaray.org/"
SRC_URI="http://static.yafaray.org/sources/${MY_PN}.${PV}.zip
	blender? (
	http://static.yafaray.org/sources/${MY_PN}-blender.${PV}.zip
	)"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blender debug qt4"

RDEPEND="
	dev-libs/libxml2
	media-libs/freetype
	media-libs/libpng
	media-libs/openexr
	sys-libs/zlib
	virtual/jpeg
	blender? ( >=media-gfx/blender-2.49 )
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-lang/swig
	>=dev-util/scons-1.0"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e 's:-Wall::g' \
		-e 's:-O3 -ffast-math::g' \
		"${S}"/config/linux2-config.py || die "sed failed"
	sed -i \
	    -e "s:env.subst('\$YF_PLUGINPATH'):\"/usr/$(get_libdir)/yafaray\":"\
		"${S}"/tools/writeconfig.py || die "sed failed"
	# add correct paths for qt-libs
	echo 'gui_env.Append(CPPPATH = ["/usr/include/qt4"])' >> "${S}"/src/gui/SConscript
	echo "gui_env.Append(LIBPATH = [\"/usr/$(get_libdir)/qt4\"])" >> "${S}"/src/gui/SConscript
}

user_config() {
	echo $@ >> "${S}"/user-config.py
}

src_configure() {
	user_config "CCFLAGS=\"${CXXFLAGS}\""
	user_config "PREFIX=\"${D}/usr\""
	user_config "BASE_LPATH=\"/usr/$(get_libdir)/\""
	user_config "YF_LIBOUT=\"\${PREFIX}/$(get_libdir)/\""
	user_config "YF_PLUGINPATH=\"\${PREFIX}/$(get_libdir)/yafaray/\""
	if use qt4; then
		user_config "WITH_YF_QT='true'"
		user_config "YF_QTDIR='/usr'"
	fi
	use debug && user_config "YF_DEBUG='true'"
}

src_compile() {
	scons ${MAKEOPTS} || die "scons failed"
	scons swig || die "scons swig failed"
}

src_install() {
	scons install || die "scons install failed"
	scons swig_install || die "scons swig_install failed"

	if use blender; then
		cd ../yafaray-blender
		insinto /usr/share/blender/scripts
		doins yafaray_ui.py
		insinto /usr/share/yafaray/blender
		doins yaf_*.py
	fi
}
