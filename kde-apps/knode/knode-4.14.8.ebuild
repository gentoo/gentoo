# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="A newsreader for KDE"
HOMEPAGE="https://www.kde.org/applications/internet/knode/"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# test fails, last checked for 4.2.96
RESTRICT=test

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep kdepim-common-libs '' 4.12.1-r1)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	agents/
	libkleo/
	libkpgp/
	messagecomposer/
	messageviewer/
	messagecore/
"
KMCOMPILEONLY="
	grantleetheme/
	kaddressbookgrantlee/
"

KMLOADLIBS="kdepim-common-libs"

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kioslave/news
		"
	fi

	kde4-meta_src_unpack
}
