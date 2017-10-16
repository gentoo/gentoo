# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
QT3SUPPORT_REQUIRED="true"
inherit kde4-meta

DESCRIPTION="Usenet newsgroups and mailing lists reader by KDE (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

# test fails, last checked for 4.2.96
RESTRICT=test

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkpgp)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gcc-6.3.patch" )

KMEXTRACTONLY="
	libkpgp/
"

KMLOADLIBS="libkdepim"

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kioslave/news
		"
	fi

	kde4-meta_src_unpack
}
