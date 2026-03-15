# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=0.015
inherit perl-module

DESCRIPTION="Details of the floating point data type"

SLOT="0"
KEYWORDS="~amd64 ~x86"

PERL_RM_FILES=( "t/pod_syn.t" "t/pod_cvg.t" )
