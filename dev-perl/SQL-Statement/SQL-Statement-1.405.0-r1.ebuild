# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=REHSACK
MODULE_VERSION=1.405
inherit perl-module

DESCRIPTION="Small SQL parser and engine"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
IUSE="test"

RDEPEND=">=dev-perl/DBI-1.616
	>=dev-perl/Clone-0.30
	>=dev-perl/Params-Util-0.35
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

pkg_setup() {
	export SQL_STATEMENT_WARN_UPDATE=sure

	if has_version "<=dev-perl/SQL-Statement-1.20" ; then
		ewarn "Changes include (1.22):"
		ewarn "  * behavior for unquoted identifiers modified to lower case them"
		ewarn "  * IN and BETWEEN operators are supported native"
	fi
}

src_test() {
	# XT tests don't normally run, but upstream...
	perl_rm_files "xt/pod.t" "xt/pod-cm.t" "xt/pod_coverage.t"
	perl-module_src_test
}
