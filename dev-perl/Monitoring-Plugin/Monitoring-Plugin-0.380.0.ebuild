# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="NIERLEIN"
MODULE_VERSION="0.38"

inherit perl-module

DESCRIPTION="Modules to streamline Nagios, Icinga, Shinken, etc. plugins"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND="dev-perl/Class-Accessor
	dev-perl/Config-Tiny
	dev-perl/Math-Calc-Units
	dev-perl/Params-Validate"

SRC_TEST=do
