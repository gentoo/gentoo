# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Used to justify strings to various alignment styles"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	>=virtual/perl-Term-ANSIColor-2.20.0"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/release-{cpan-changes,kwalitee,trailing-space}.t \
	   			  t/author-{no-tabs,pod-{coverage,syntax}}.t

	perl-module_src_test
}
