# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RUBYKAT
MODULE_VERSION=2.5201

inherit perl-module

DESCRIPTION="Convert plain text file to HTML."

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/YAML-Syck
	"

SRC_TEST="do"
