# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PATL
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Easily timeout long running operations"

SLOT="0"
KEYWORDS="~amd64 ~x86"

PERL_RM_FILES=( "t/pod.t" )
