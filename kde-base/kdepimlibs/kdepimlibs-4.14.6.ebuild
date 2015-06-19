# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepimlibs/kdepimlibs-4.14.6.ebuild,v 1.1 2015/03/29 13:14:07 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug ldap prison"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	!kde-misc/akonadi-social-utils
	>=app-crypt/gpgme-1.1.6
	>=app-office/akonadi-server-1.12.90[qt4]
	>=dev-libs/boost-1.35.0-r5:=
	dev-libs/libgpg-error
	>=dev-libs/libical-0.48-r2:=
	dev-libs/cyrus-sasl
	>=dev-libs/qjson-0.8.1
	media-libs/phonon[qt4]
	x11-misc/shared-mime-info
	prison? ( media-libs/prison:4 )
	ldap? ( net-nds/openldap )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}
	!=kde-base/kdepim-runtime-4.10*
	!=kde-base/kdepim-runtime-4.11*
	!<kde-base/kdepim-runtime-4.4.11.1-r2
"

PATCHES=( "${FILESDIR}/${PN}-4.9.1-boostincludes.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_find_package ldap)
		$(cmake-utils_use_find_package prison)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install
	rm "${ED}"/usr/share/apps/cmake/modules/FindQtOAuth.cmake #Collides with net-im/choqok
}
