# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu-qt/libdbusmenu-qt-0.9.3_pre20140619.ebuild,v 1.2 2015/01/30 20:40:55 johu Exp $

EAPI=5

EBZR_REPO_URI="lp:libdbusmenu-qt"

[[ ${PV} == 9999* ]] && BZR_ECLASS="bzr"
inherit cmake-utils multibuild virtualx ${BZR_ECLASS}

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
if [[ ${PV} == 9999* ]] ; then
	KEYWORDS=""
else
	MY_PV=${PV/_pre/+14.10.}
	SRC_URI="http://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
	# upstream has no permissions to use some kde written code so repack git
	# repo every time
	#SRC_URI="http://dev.gentoo.org/~scarabeus/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
	PATCHES=( "${FILESDIR}/${P}-optionaltests.patch" )
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +qt4 qt5"
S=${WORKDIR}/${PN}-${MY_PV}

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
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
		dev-libs/qjson
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( NEWS README )

# tests fail due to missing connection to dbus
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_prepare() {
	[[ ${PV} == 9999* ]] && bzr_src_prepare
	cmake-utils_src_prepare

	use test || comment_add_subdirectory tests
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			$(cmake-utils_use_with doc)
		)

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]] ; then
			mycmakeargs+=( -DUSE_QT4=ON )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]] ; then
			mycmakeargs+=( -DUSE_QT5=ON )
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	mytest() {
		local builddir=${BUILD_DIR}

		BUILD_DIR=${BUILD_DIR}/tests \
			VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

		BUILD_DIR=${builddir}
	}

	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
