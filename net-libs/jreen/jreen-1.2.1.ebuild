# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/euroelessar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~ppc x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI=( "git://github.com/euroelessar/${PN}" )
fi

inherit cmake-utils multibuild ${GIT_ECLASS}

DESCRIPTION="Qt XMPP library"
HOMEPAGE="https://github.com/euroelessar/jreen"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	media-libs/speex
	net-libs/libgsasl
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README.md )
PATCHES=( "${FILESDIR}/${PN}-qt5.6.patch" )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DJREEN_FORCE_QT4=ON )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=( -DJREEN_FORCE_QT4=OFF )
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

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}
