# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalarm/kalarm-4.4.11.1-r2.ebuild,v 1.9 2014/04/05 18:08:59 dilfridge Exp $

EAPI=5

KMNAME="kdepim"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler for KDE"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)' 4.6)
	$(add_kdebase_dep libkdepim)
"
DEPEND="${RDEPEND}
	dev-libs/boost:=
	dev-libs/libxslt
"

KMEXTRACTONLY="
	kmail/
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.11.1-underlinking.patch"
	"${FILESDIR}/4.4/"000{1,3,6}-*.patch
)

src_configure() {
	mycmakeargs=(
		-DBUILD_akonadi=OFF
		-DXSLTPROC_EXECUTABLE="${EPREFIX}"/usr/bin/xsltproc
	)
	kde4-meta_src_configure
}
