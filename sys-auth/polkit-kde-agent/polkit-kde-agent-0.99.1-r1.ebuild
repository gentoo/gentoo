# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="${PN}-1"
MY_P="${MY_PN}-${PV}"
EGIT_REPONAME="${MY_PN}"
KDE_LINGUAS="ar bs ca ca@valencia cs da de el en_GB eo es et fi fr
	ga gl hr hu is it ja kk km lt mai mr ms nb nds nl pa pl pt pt_BR
	ro ru sk sl sr sr@ijekavian sr@ijekavianlatin sr@latin sv th tr
	ug uk vi zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="PolKit agent module for KDE"
HOMEPAGE="https://www.kde.org"
if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_PN/-agent/}_${PV}.orig.tar.xz"
fi

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"
SLOT="4"
IUSE="debug minimal"

RDEPEND="
	>=sys-auth/polkit-qt-0.103.0[qt4(+)]
	!sys-auth/polkit-kde
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	S=${WORKDIR}/${MY_P}
fi

src_prepare() {
	kde4-base_src_prepare

	# Coinstallability with kde-plasma/polkit-kde-agent
	use minimal && rm -rf po
}
