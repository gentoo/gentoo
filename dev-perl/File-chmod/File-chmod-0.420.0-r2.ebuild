# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=XENO
DIST_VERSION=0.42
inherit perl-module

DESCRIPTION="Implements symbolic and ls chmod modes"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~sparc x86 ~x64-macos ~x64-solaris"

PERL_RM_FILES=(
	t/author-critic.t
	t/author-eol.t
	t/release-cpan-changes.t
	t/release-dist-manifest.t
	t/release-meta-json.t
	t/release-minimum-version.t
	t/release-pod-coverage.t
	t/release-pod-syntax.t
	t/release-portability.t
	t/release-test-version.t
	t/release-unused-vars.t
)
