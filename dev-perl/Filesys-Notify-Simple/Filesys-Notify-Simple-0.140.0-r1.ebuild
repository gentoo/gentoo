# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Simple and dumb file system watcher"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86"

BDEPEND="
	test? (
		dev-perl/Test-SharedFork
	)
"

PERL_RM_FILES=(
	t/author-pod-syntax.t
)
