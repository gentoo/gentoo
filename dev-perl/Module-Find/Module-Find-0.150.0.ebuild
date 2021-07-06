# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CRENZ
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Find and use installed modules in a (sub)category"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x86-solaris"

PERL_RM_FILES=( t/pod.t t/meta.t t/pod-coverage.t )
