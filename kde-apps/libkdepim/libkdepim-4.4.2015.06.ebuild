# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Common library for KDE PIM apps (noakonadi branch)"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	korganizer/korgac/org.kde.korganizer.KOrgac.xml
	kaddressbook/org.kde.KAddressbook.Core.xml
"

KMSAVELIBS="true"

# the one test that can be run requires a dbus session bus
RESTRICT=test

src_install() {
	kde4-meta_src_install

	# install additional generated headers that are needed by other packages that
	# are derived from kdepim. e.g. kmail.
	pushd "${CMAKE_BUILD_DIR}/libkdepim/" 2>/dev/null || die "pushd libkdepim failed"
	insinto "${PREFIX}/include"
	doins ui_addresspicker.h ui_categoryselectdialog_base.h || die "Failed to install extra header files."
	popd 2>/dev/null
}
