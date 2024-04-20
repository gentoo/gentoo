# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="TRIPIE"
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="A module to highlight words or patterns in HTML documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/fix-pod.patch )
