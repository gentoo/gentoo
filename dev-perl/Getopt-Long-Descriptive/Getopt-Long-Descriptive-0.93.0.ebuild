# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Getopt-Long-Descriptive/Getopt-Long-Descriptive-0.93.0.ebuild,v 1.4 2014/07/26 14:07:54 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.093
inherit perl-module

DESCRIPTION="Getopt::Long with usage text"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Params-Validate-0.970.0
	dev-perl/IO-stringy
	dev-perl/Sub-Exporter
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}"

SRC_TEST=do
