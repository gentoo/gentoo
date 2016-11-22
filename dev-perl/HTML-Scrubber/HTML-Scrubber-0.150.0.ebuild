# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NIGELM
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND="dev-perl/HTML-Parser"
DEPEND="${REPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Memory-Cycle
	)"

SRC_TEST="do"

src_test() {
	perl_rm_files t/author-no-tabs.t t/release-unused-vars.t \
		t/release-has-version.t t/author-critic.t \
		t/release-minimum-version.t t/release-dist-manifest.t \
		t/author-eol.t t/release-pod-syntax.t \
		t/release-distmeta.t t/author-pod-spell.t \
		t/release-portability.t t/000-report-versions.t \
		t/release-synopsis.t
	perl-module_src_test
}
