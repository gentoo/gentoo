# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Address book application (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.10_p20160611)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
"
RDEPEND="${DEPEND}
	!>kde-apps/kdepimlibs-4.14.11_pre20160211
"

KMEXTRA="
	plugins/kaddressbook/
	plugins/ktexteditor/
"
KMEXTRACTONLY="
	libkleo/
"

KMLOADLIBS="libkdepim"

src_install() {
	kde4-meta_src_install

	# file collision with kde-apps/kdepimlibs-4.14.9
	rm -f "${ED}usr/share/kde4/servicetypes/kaddressbookimprotocol.desktop" || die

	# install additional headers needed by kresources
	insinto "${KDEDIR}"/include/${PN}
	doins "${CMAKE_BUILD_DIR}"/${PN}/common/*.h
	doins "${S}"/${PN}/common/*.h
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
}
