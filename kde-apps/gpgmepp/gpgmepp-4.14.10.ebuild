# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepimlibs"
EGIT_BRANCH="KDE/4.14"
inherit kde4-base

DESCRIPTION="C++ bindings for gpgme"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
IUSE="debug"

DEPEND="
	>=app-crypt/gpgme-1.1.6
	>=dev-libs/boost-1.35.0-r5:=
	dev-libs/libgpg-error
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}
	!kde-apps/kdepimlibs:4
"

PATCHES=( "${FILESDIR}/kdepimlibs-4.9.1-boostincludes.patch" )

S="${WORKDIR}/${KMNAME}-${PV}"

src_prepare() {
	comment_add_subdirectory kmime
	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_doc=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Prison=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Ldap=ON
		-DKDEPIM_ONLY_KLEO=ON
		-DKDEPIM_NO_KCAL=ON
		-DKDEPIM_NO_KRESOURCES=ON
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install
	rm -f "${ED}"usr/share/apps/cmake/modules/CheckTimezone.cmake \
		"${ED}"usr/share/apps/cmake/modules/Find{Ldap,Libical,QtOAuth}.cmake \
		"${ED}"usr/share/doc/"${PF}"/{akonadi,kabc,kalarmcal,kresources,kxmlrpcclient}.README* \
		"${ED}"usr/share/doc/"${PF}"/{kabc,kmime,kresources,mailtransport}.TODO* \
		"${ED}"usr/share/doc/"${PF}"/kabc.HACKING* \
		"${ED}"usr/share/doc/"${PF}"/ktnef.AUTHORS || die
}
