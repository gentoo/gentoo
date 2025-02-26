# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CRENZ
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Find and use installed modules in a (sub)category"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

PERL_RM_FILES=( t/pod.t t/meta.t t/pod-coverage.t )
