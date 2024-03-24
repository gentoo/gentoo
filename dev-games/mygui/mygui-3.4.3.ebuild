# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=(FindFreetype)
inherit cmake flag-o-matic

MY_PN=MyGUI
MY_P=${MY_PN}${PV}

DESCRIPTION="A library for creating GUIs for games and 3D applications"
HOMEPAGE="http://mygui.info"
SRC_URI="https://github.com/MyGUI/mygui/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}" # soname
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="debug doc +ogre opengl plugins samples static-libs test tools l10n_ru"
RESTRICT="!test? ( test )"
REQUIRED_USE="ogre? ( !opengl )
	opengl? ( !ogre )"

RDEPEND="media-libs/freetype:2
	sys-libs/zlib
	ogre? (
		>=dev-games/ogre-1.12:0=[freeimage,opengl]
		samples? ( dev-games/ois )
	)
	opengl? (
		virtual/opengl
		media-libs/glew:0=
	)
	tools? ( dev-games/ois )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-text/doxygen )"

S=${WORKDIR}/mygui-${MY_P}
STATIC_BUILD=${WORKDIR}/${P}_build_static

PATCHES=(
	"${FILESDIR}"/mygui-3.4.1-build.patch
	"${FILESDIR}"/mygui-3.4.1-FHS.patch
	"${FILESDIR}"/mygui-3.4.3-werror.patch
)

pkg_setup() {
	if use samples && use !ogre ; then
		ewarn "Samples disabled, because they only work with ogre!"
		ewarn "Enable ogre USE flag if you want to use samples."
	fi
}

src_configure() {
	use debug && append-cppflags -DDEBUG

	local mycmakeargs=()

	# static configuration
	if use static-libs ; then
		mycmakeargs=( -DMYGUI_STATIC=ON
			-DMYGUI_DONT_USE_OBSOLETE=ON
			-DMYGUI_BUILD_DOCS=OFF
			-DMYGUI_INSTALL_DOCS=OFF
			-DMYGUI_USE_FREETYPE=ON
			-DMYGUI_BUILD_PLUGINS=$(usex plugins)
			-DMYGUI_BUILD_DEMOS=OFF
			-DMYGUI_INSTALL_DEMOS=OFF
			-DMYGUI_BUILD_TOOLS=OFF
			-DMYGUI_INSTALL_TOOLS=OFF
			-DMYGUI_BUILD_WRAPPER=OFF
			-DMYGUI_RENDERSYSTEM=$(usex opengl "4" "$(usex ogre "3" "1")") )

		CMAKE_BUILD_DIR=${STATIC_BUILD} cmake_src_configure
		unset mycmakeargs
	fi

	# main configuration
	mycmakeargs=(
		-DMYGUI_STATIC=OFF
		-DMYGUI_BUILD_DOCS=$(usex doc)
		-DMYGUI_INSTALL_DOCS=$(usex doc)
		-DMYGUI_USE_FREETYPE=ON
		-DMYGUI_BUILD_PLUGINS=$(usex plugins)
		-DMYGUI_BUILD_TOOLS=$(usex tools)
		-DMYGUI_INSTALL_TOOLS=$(usex tools)
		-DMYGUI_USE_SYSTEM_GLEW=$(usex opengl)
		-DMYGUI_BUILD_WRAPPER=OFF
		-DMYGUI_DONT_USE_OBSOLETE=ON
		-DMYGUI_RENDERSYSTEM=$(usex opengl "4" "$(usex ogre "3" "1")")
	)

	if use ogre && use samples; then
		mycmakeargs+=(
			-DMYGUI_BUILD_DEMOS=ON
			-DMYGUI_INSTALL_DEMOS=ON
		)
	else
		mycmakeargs+=(
			-DMYGUI_BUILD_DEMOS=OFF
			-DMYGUI_INSTALL_DEMOS=OFF
		)

	fi

	if use tools || (use samples && use ogre) ; then
		mycmakeargs+=( -DMYGUI_INSTALL_MEDIA=ON )
	else
		mycmakeargs+=( -DMYGUI_INSTALL_MEDIA=OFF )
	fi

	cmake_src_configure
}

src_compile() {
	# build system does not support building static and shared at once,
	# run a double build
	if use static-libs ; then
		CMAKE_BUILD_DIR=${STATIC_BUILD} cmake_src_compile
	fi

	cmake_src_compile

	use doc && emake -C "${CMAKE_BUILD_DIR}"/Docs api-docs
}

src_install() {
	cmake_src_install

	if use static-libs ; then
		find "${STATIC_BUILD}" -name "*.a" \! -name "libCommon.a" -exec dolib.a '{}' \;
		insinto /usr/$(get_libdir)/pkgconfig
		doins "${STATIC_BUILD}"/pkgconfig/MYGUIStatic.pc
	fi

	if use doc ; then
		dodoc -r "${CMAKE_BUILD_DIR}"/Docs/html/

		if use l10n_ru ; then
			docompress -x /usr/share/doc/${PF}/Papers
			dodoc -r Docs/Papers
		fi
	fi

	keepdir /etc/MYGUI
	fperms o+w /etc/MYGUI

	# test media not needed at runtime
	rm -rf "${ED}"/usr/share/MYGUI/Media/UnitTests || die
	# wrapper not available for linux, remove related media
	rm -rf "${ED}"/usr/share/MYGUI/Media/Wrapper || die
}

pkg_postinst() {
	elog
	elog "ogre.cfg and Ogre.log are created as"
	elog "${EROOT}/etc/MYGUI/mygui-ogre.cfg and /etc/MYGUI/mygui-Ogre.log"
	elog
}
