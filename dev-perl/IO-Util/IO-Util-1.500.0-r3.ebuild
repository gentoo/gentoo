# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOMIZIO
DIST_VERSION=1.5
inherit perl-module

DESCRIPTION="A selection of general-utility IO function"

SLOT="0"
KEYWORDS="amd64 x86"

PERL_RM_FILES=( t/test_pod.t t/test_pod_coverage.t )
