# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="TRIPIE"
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="A module to highlight words or patterns in HTML documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
PATCHES=( "${FILESDIR}"/fix-pod.patch )
