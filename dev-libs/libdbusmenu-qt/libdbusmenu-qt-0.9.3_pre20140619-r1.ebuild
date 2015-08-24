# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBZR_REPO_URI="lp:libdbusmenu-qt"

[[ ${PV} == 9999* ]] && BZR_ECLASS="bzr"
inherit multibuild multilib virtualx ${BZR_ECLASS} cmake-multilib

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
if [[ ${PV} == 9999* ]] ; then
	KEYWORDS=""
else
	MY_PV=${PV/_pre/+14.10.}
	SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
	# upstream has no permissions to use some kde written code so repack git
	# repo every time
	#SRC_URI="https://dev.gentoo.org/~scarabeus/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
	PATCHES=( "${FILESDIR}/${P}-optionaltests.patch" )
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +qt4 qt5"
S=${WORKDIR}/${PN}-${MY_PV}

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? (
		>=dev-qt/qtcore-4.8.6:4[${MULTILIB_USEDEP}]
		>=dev-qt/qtdbus-4.8.6:4[${MULTILIB_USEDEP}]
		>=dev-qt/qtgui-4.8.6:4[${MULTILIB_USEDEP}]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		dev-libs/qjson[${MULTILIB_USEDEP}]
		qt4? ( >=dev-qt/qttest-4.8.6:4[${MULTILIB_USEDEP}] )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( NEWS README )

# tests fail due to missing connection to dbus
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usex qt4 4) $(usex qt5 5) )
}

src_prepare() {
	[[ ${PV} == 9999* ]] && bzr_src_prepare
	cmake-utils_src_prepare

	comment_add_subdirectory tools
	use test || comment_add_subdirectory tests
}

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with doc)
		-DUSE_QT${QT_MULTIBUILD_VARIANT}=ON
		-DQT_QMAKE_EXECUTABLE="/usr/$(get_libdir)/qt${QT_MULTIBUILD_VARIANT}/bin/qmake"
	)
	cmake-utils_src_configure
}

src_configure() {
	myconfigure() {
		local QT_MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_configure
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_configure
		fi
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_compile
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_compile
		fi
	}

	multibuild_foreach_variant mycompile
}

src_install() {
	myinstall() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_install
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_install
		fi
	}

	multibuild_foreach_variant myinstall
}

src_test() {
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_test
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_test
		fi
	}

	multibuild_foreach_variant mytest
}

multilib_src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests \
		VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

	BUILD_DIR=${builddir}
}
