# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Structure-Util/Data-Structure-Util-0.150.0.ebuild,v 1.5 2014/11/03 19:59:31 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ANDYA
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Change nature of data within a structure"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
virtual/perl-Digest-MD5
virtual/perl-Scalar-List-Utils

"
DEPEND="${RDEPEND}"
