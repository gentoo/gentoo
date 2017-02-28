# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GRAF
MODULE_VERSION=0.002000
inherit perl-module

DESCRIPTION="Auto-create boolean objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/SQL-Translator
	dev-perl/Path-Class
	>=dev-perl/DBIx-Class-0.81.70
	>=dev-perl/Contextual-Return-0.4.7
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do

src_prepare() {
	# Module::Install causes fun problems if these are nuked after
	# Makefile.PL
	use test && perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_prepare
}
