# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TINITA
DIST_VERSION=0.63
inherit perl-module

DESCRIPTION="Perl YAML Serialization using XS and libyaml"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
export OPTIMIZE="$CFLAGS"

src_test() {
	perl_rm_files t/author-pod-syntax.t
	perl-module_src_test
}
