# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=2.08
inherit perl-module

DESCRIPTION="Patch perl source a la Devel::PPPort's buildperl.pl"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/File-pushd-1.0.0
	dev-perl/Module-Pluggable
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/author-pod-coverage.t
	t/author-pod-syntax.t
)
