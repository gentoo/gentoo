# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libktorrent/libktorrent-1.3.1.ebuild,v 1.8 2015/01/29 01:39:03 johu Exp $

EAPI=5

KDE_SCM="git"
if [[ ${PV} != 9999* ]]; then
	inherit versionator
	# upstream likes to skip that _ in beta releases
	MY_PV="${PV/_/}"
	KTORRENT_VERSION=$(($(get_major_version)+3)).$(get_version_component_range 2-3 ${MY_PV})
	MY_P="${PN}-${MY_PV}"
	KDE_HANDBOOK="optional"
	KDE_DOC_DIRS="doc"

	KDE_LINGUAS="ar ast be bg bs ca ca@valencia cs da de el en_GB eo es et eu
		fi fr ga gl hi hne hr hu is it ja km ku lt lv ms nb nds nl nn oc pl
		pt pt_BR ro ru se si sk sl sr sr@ijekavian sr@ijekavianlatin
		sr@latin sv tr ug uk zh_CN zh_TW"
	SRC_URI="http://ktorrent.org/downloads/${KTORRENT_VERSION}/${MY_P}.tar.bz2"
	S="${WORKDIR}"/"${MY_P}"

	KEYWORDS="amd64 ~arm ppc ppc64 x86"
else
	KEYWORDS=""
fi
VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="A BitTorrent library based on KDE Platform"
HOMEPAGE="http://ktorrent.org/"

LICENSE="GPL-2"
SLOT="4"
IUSE="debug"

RDEPEND="
	app-crypt/qca:2[qt4(+)]
	dev-libs/gmp
	dev-libs/libgcrypt:0
"
DEPEND="${RDEPEND}
	dev-libs/boost
	sys-devel/gettext
"

src_prepare() {
	kde4-base_src_prepare
	# do not build non-installed example binary
	sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt || die
}
