# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Database for the m17n library"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="virtual/libintl"

src_install() {
	default

	docinto FORMATS
	dodoc FORMATS/*

	docinto UNIDATA
	dodoc UNIDATA/*
}
