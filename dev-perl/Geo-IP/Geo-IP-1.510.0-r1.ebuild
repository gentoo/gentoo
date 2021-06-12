# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.51
inherit perl-module

DESCRIPTION="Look up country by IP Address"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-libs/geoip"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	myconf="LIBS=-L/usr/$(get_libdir)"
	perl-module_src_configure
}
