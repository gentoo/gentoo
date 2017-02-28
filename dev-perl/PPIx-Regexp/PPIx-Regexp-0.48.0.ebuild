# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=WYANT
DIST_VERSION=0.048
inherit perl-module

DESCRIPTION="Represent a regular expression of some sort"

SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 x86"
IUSE="test examples"

RDEPEND="
	dev-perl/List-MoreUtils
	>=dev-perl/PPI-1.117.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r eg/*
	fi
}
