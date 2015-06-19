# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit-qt/polkit-qt-0.112.0-r1.ebuild,v 1.6 2015/05/16 10:14:07 jer Exp $

EAPI=5

MY_P="${P/qt/qt-1}"

inherit cmake-utils multibuild

DESCRIPTION="PolicyKit Qt4 API wrapper library"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/apps/KDE4.x/admin/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~x86-fbsd"
IUSE="debug examples +qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	dev-libs/glib:2
	>=sys-auth/polkit-0.103
	qt4? (
		dev-qt/qtcore:4[glib]
		dev-qt/qtdbus:4
		dev-qt/qtgui:4[glib]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		examples? ( dev-qt/qtxml:5 )
	)
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README README.porting TODO )

S=${WORKDIR}/${MY_P}

# bug #529686
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	use qt4 && MULTIBUILD_VARIANTS+=( qt4 )
	use qt5 && MULTIBUILD_VARIANTS+=( qt5 )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
			$(cmake-utils_use_build examples)
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

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
