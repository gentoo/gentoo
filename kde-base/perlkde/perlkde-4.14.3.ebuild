# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE Perl bindings"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="akonadi attica debug kate okular test"

RDEPEND="
	>=dev-lang/perl-5.10.1:=
	$(add_kdebase_dep perlqt)
	$(add_kdebase_dep smokekde 'akonadi?,attica?,kate?,okular?')
"
DEPEND="${RDEPEND}
	test? ( dev-perl/List-MoreUtils )
"

PATCHES=( "${FILESDIR}/${PN}-4.11.3-vendor.patch" )

RESTRICT="test"
# yes they all fail.

src_configure() {
	local mycmakeargs=(
		-DWITH_Nepomuk=OFF
		-DWITH_Soprano=OFF
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_disable kate)
		$(cmake-utils_use_with okular)
	)
	kde4-base_src_configure
}
