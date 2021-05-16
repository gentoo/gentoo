# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GTERMARS
DIST_VERSION="0.09"

inherit perl-module

DESCRIPTION="XS based CSS minifier"

SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	>=dev-perl/Module-Build-0.40.0
	virtual/perl-ExtUtils-CBuilder
"
src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_configure
}
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}
