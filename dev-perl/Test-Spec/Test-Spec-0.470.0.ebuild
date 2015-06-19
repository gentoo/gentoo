# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Spec/Test-Spec-0.470.0.ebuild,v 1.1 2014/12/09 21:20:21 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=PHILIP
MODULE_VERSION=0.47
inherit perl-module

DESCRIPTION='Write tests in a declarative specification style'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Package-Stash-0.230.0
	virtual/perl-Test-Harness
	>=dev-perl/Test-Deep-0.103.0
	virtual/perl-Test-Simple
	dev-perl/Test-Trap
	dev-perl/Tie-IxHash
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
