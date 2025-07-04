# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FVOX
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Extract audio from Flash Videos"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Moose
"

BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/author-critic.t
	t/release-distmeta.t
	t/release-eol.t
	t/release-pod-coverage.t
	t/release-pod-syntax.t
)
