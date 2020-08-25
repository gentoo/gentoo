# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JGMYERS
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="An Encode::Encoding subclass that detects the encoding of data"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

DEPEND="dev-perl/Module-Build"
BDEPEND="
	dev-perl/Module-Build
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
