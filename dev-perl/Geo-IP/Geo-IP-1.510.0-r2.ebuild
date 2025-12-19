# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.51
inherit perl-module

DESCRIPTION="Look up country by IP Address"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="dev-libs/geoip"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	myconf="LIBS=-L/usr/$(get_libdir)"
	perl-module_src_configure
}
