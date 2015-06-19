# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/YAML-LibYAML/YAML-LibYAML-0.590.0.ebuild,v 1.1 2015/06/03 20:12:08 monsieurp Exp $

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
