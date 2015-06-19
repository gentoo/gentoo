# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/mygui/mygui-3.2.2.ebuild,v 1.3 2015/04/19 10:06:20 ago Exp $

EAPI=5
CMAKE_REMOVE_MODULES="yes"
CMAKE_REMOVE_MODULES_LIST="FindFreetype"
inherit eutils cmake-utils flag-o-matic multilib

MY_PN=MyGUI
MY_P=${MY_PN}${PV}

DESCRIPTION="A library for creating GUIs for games"
HOMEPAGE="http://mygui.info/"
SRC_URI="https://github.com/MyGUI/mygui/archive/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc +ogre -opengl plugins samples static-libs test tools linguas_ru"
REQUIRED_USE="ogre? ( !opengl )
	opengl? ( !ogre )"

RDEPEND="
	media-libs/freetype:2
	ogre? (
		dev-games/ogre:=[freeimage,opengl]
		samples? ( dev-games/ois )
	)
	opengl? ( virtual/opengl
		media-libs/glew )
	tools? ( dev-games/ois )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/mygui-${MY_P}
STATIC_BUILD=${WORKDIR}/${P}_build_static

pkg_setup() {
	if use samples && use !ogre ; then
		ewarn "Samples disabled, because they only work with ogre!"
		ewarn "Enable ogre USE flag if you want to use samples."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-FHS.patch
}

src_configure() {
	use debug && append-cppflags -DDEBUG

	local mycmakeargs=()

	# static configuration
	if use static-libs ; then
		mycmakeargs=( -DMYGUI_STATIC=ON
			-DMYGUI_BUILD_DOCS=OFF
			-DMYGUI_INSTALL_DOCS=OFF
			-DMYGUI_USE_FREETYPE=ON
			$(cmake-utils_use plugins MYGUI_BUILD_PLUGINS)
			-DMYGUI_BUILD_DEMOS=OFF
			-DMYGUI_INSTALL_SAMPLES=OFF
			-DMYGUI_BUILD_TOOLS=OFF
			-DMYGUI_INSTALL_TOOLS=OFF
			-DMYGUI_BUILD_WRAPPER=OFF
			-DMYGUI_RENDERSYSTEM=$(usex opengl "4" "$(usex ogre "3" "1")") )

		CMAKE_BUILD_DIR=${STATIC_BUILD} cmake-utils_src_configure
		unset mycmakeargs
	fi

	# main configuration
	mycmakeargs=( -DMYGUI_STATIC=OFF
		$(cmake-utils_use doc MYGUI_BUILD_DOCS)
		$(cmake-utils_use doc MYGUI_INSTALL_DOCS)
		-DMYGUI_USE_FREETYPE=ON
		$(cmake-utils_use plugins MYGUI_BUILD_PLUGINS)
		$(usex ogre "$(cmake-utils_use samples MYGUI_BUILD_DEMOS)" "-DMYGUI_BUILD_DEMOS=OFF")
		$(usex ogre "$(cmake-utils_use samples MYGUI_INSTALL_SAMPLES)" "-DMYGUI_INSTALL_SAMPLES=OFF")
		$(cmake-utils_use tools MYGUI_BUILD_TOOLS)
		$(cmake-utils_use tools MYGUI_INSTALL_TOOLS)
		$(cmake-utils_use opengl MYGUI_USE_SYSTEM_GLEW)
		-DMYGUI_BUILD_WRAPPER=OFF
		-DMYGUI_RENDERSYSTEM=$(usex opengl "4" "$(usex ogre "3" "1")") )

	if use tools || (use samples && use ogre) ; then
		mycmakeargs+=( -DMYGUI_INSTALL_MEDIA=ON )
	else
		mycmakeargs+=( -DMYGUI_INSTALL_MEDIA=OFF )
	fi

	cmake-utils_src_configure
}

src_compile() {
	# build system does not support building static and shared at once,
	# run a double build
	if use static-libs ; then
		CMAKE_BUILD_DIR=${STATIC_BUILD} cmake-utils_src_compile
	fi

	cmake-utils_src_compile

	use doc && emake -C "${CMAKE_BUILD_DIR}"/Docs api-docs
}

src_install() {
	cmake-utils_src_install

	if use static-libs ; then
		find "${STATIC_BUILD}" -name "*.a" \! -name "libCommon.a" -exec dolib.a '{}' \;
		insinto /usr/$(get_libdir)/pkgconfig
		doins "${STATIC_BUILD}"/pkgconfig/MYGUIStatic.pc
	fi

	if use doc ; then
		dohtml -r "${CMAKE_BUILD_DIR}"/Docs/html/*

		if use linguas_ru ; then
			docompress -x /usr/share/doc/${PF}/Papers
			dodoc -r Docs/Papers
		fi
	fi

	keepdir /etc/MYGUI
	fperms o+w /etc/MYGUI

	# test media not needed at runtime
	rm -rf "${D}"/usr/share/MYGUI/Media/UnitTests
	# wrapper not available for linux, remove related media
	rm -rf "${D}"/usr/share/MYGUI/Media/Wrapper
}

pkg_postinst() {
	einfo
	elog "ogre.cfg and Ogre.log are created as"
	elog "/etc/MYGUI/mygui-ogre.cfg and /etc/MYGUI/mygui-Ogre.log"
	einfo
}
