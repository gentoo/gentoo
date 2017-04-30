# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Usenet newsgroups and mailing lists reader by KDE"
HOMEPAGE="https://www.kde.org/applications/internet/knode/"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# test fails, last checked for 4.2.96
RESTRICT=test

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepimlibs)
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
