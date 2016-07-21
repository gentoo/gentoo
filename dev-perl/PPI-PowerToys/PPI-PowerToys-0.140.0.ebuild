# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="ADAMK"
MODULE_VERSION=0.14

inherit perl-module

DESCRIPTION="A handy collection of small PPI-based utilities"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-perl/File-Find-Rule-0.32
	>=dev-perl/File-Find-Rule-Perl-1.10
	>=dev-perl/Test-Script-1.70.0
	>=dev-perl/Probe-Perl-0.01
	dev-perl/PPI
	dev-perl/IPC-Run3
"
