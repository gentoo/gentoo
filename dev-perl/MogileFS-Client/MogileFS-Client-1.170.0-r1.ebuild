# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Client library for the MogileFS distributed file system"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-perl/IO-stringy-2.110
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}"

# Tests only available if you have a local mogilefsd on 127.0.0.1:7001
#SRC_TEST="do"
