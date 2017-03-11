# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KMNAME="kdepim"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="Kleopatra - KDE X.509 key manager (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.10-r3)
	$(add_kdeapps_dep libkdepim '' 4.4.2015)
	$(add_kdeapps_dep libkleo '' 4.4.2015)
	app-crypt/gpgme
	>=dev-libs/libassuan-2.0.0
	dev-libs/libgpg-error
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

RESTRICT=test
# bug 399431

KMEXTRACTONLY="
	libkleo
"
KMLOADLIBS="libkleo"

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kwatchgnupg
		"
	fi

	kde4-meta_src_unpack
}

src_configure() {
	mycmakeargs=(
		-DWITH_QGPGME=ON
	)

	kde4-meta_src_configure
}
