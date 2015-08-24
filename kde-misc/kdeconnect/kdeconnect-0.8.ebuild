# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN}-kde"
DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="ar bg bs ca cs da de es fi fr gl hu it ja ko lt nl pl pt pt_BR ro ru sk sv tr uk"
inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	MY_P="${MY_PN}-${PV}"
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="git://anongit.kde.org/${MY_PN}"
	KEYWORDS=""
fi

DESCRIPTION="Adds communication between KDE and your smartphone"
HOMEPAGE="https://www.kde.org/"

LICENSE="GPL-2+"
SLOT="4"
IUSE="debug"

COMMON_DEPEND="
	app-crypt/qca:2[qt4(+)]
	dev-libs/qjson
	x11-libs/libfakekey
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdebase_dep plasma-workspace)
	app-crypt/qca:2[openssl]
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"

[[ ${KDE_BUILD_TYPE} != live ]] && S=${WORKDIR}/${MY_P}

pkg_postinst(){
	elog
	elog "Optional dependency:"
	elog "sys-fs/sshfs-fuse (for 'remote filesystem browser' plugin)"
	elog
	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog
}
