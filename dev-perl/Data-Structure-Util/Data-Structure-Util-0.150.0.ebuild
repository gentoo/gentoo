# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ANDYA
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Change nature of data within a structure"

SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="
virtual/perl-Digest-MD5
virtual/perl-Scalar-List-Utils

"
DEPEND="${RDEPEND}"
