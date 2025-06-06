# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DDICK
DIST_VERSION=0.54
inherit perl-module

DESCRIPTION="Provide non blocking randomness"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"

PERL_RM_FILES=( t/pod.t )
