# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.59
inherit perl-module

DESCRIPTION='Perl YAML Serialization using XS and libyaml'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
export OPTIMIZE="$CFLAGS"
