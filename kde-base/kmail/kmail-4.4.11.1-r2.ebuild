# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmail/kmail-4.4.11.1-r2.ebuild,v 1.5 2015/02/16 08:31:41 ago Exp $

EAPI=5

KMNAME="kdepim"
KDE_HANDBOOK=optional
VIRTUALX_REQUIRED=test
inherit flag-o-matic kde4-meta

DESCRIPTION="KMail is the email component of Kontact, the integrated personal information manager of KDE"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdelibs 'nepomuk' 4.13.1)
	$(add_kdebase_dep kdepimlibs '' 4.13.1)
	$(add_kdebase_dep libkdepim '' 4.4.11.1-r1)
	$(add_kdebase_dep libkleo)
	$(add_kdebase_dep libkpgp)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdepim-runtime)
"

KMEXTRACTONLY="
	korganizer/org.kde.Korganizer.Calendar.xml
	libkleo/
	libkpgp/
"
KMEXTRA="
	kmailcvt/
	ksendemail/
	libksieve/
	messagecore/
	messagelist/
	messageviewer/
	mimelib/
	plugins/kmail/
"
KMLOADLIBS="libkdepim"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.9-nodbus.patch"
	"${FILESDIR}/4.4/"000{2,4,5}-*.patch
)

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	mycmakeargs=(
		-DWITH_IndicateQt=OFF
	)

	kde4-meta_src_configure
}

src_compile() {
	kde4-meta_src_compile kmail_xml
	kde4-meta_src_compile
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
	if ! has_version kde-base/kleopatra:${SLOT}; then
		echo
		elog "For certificate management and the gnupg log viewer, please install kde-base/kleopatra:${SLOT}"
		echo
	fi
}
