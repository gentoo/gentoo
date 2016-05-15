# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE library for encryption handling"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/gpgme
	$(add_kdeapps_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

KMSAVELIBS="true"
KMEXTRACTONLY="kleopatra/"
