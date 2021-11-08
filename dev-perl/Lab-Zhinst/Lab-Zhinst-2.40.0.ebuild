# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" != "9999" ]]; then
	DIST_VERSION=2.04
	DIST_AUTHOR=AMBA
	inherit perl-module
	KEYWORDS="~amd64"
else
	EGIT_REPO_URI="https://github.com/lab-measurement/Lab-Zhinst.git"
	EGIT_BRANCH="master"
	inherit perl-module git-r3
fi

DESCRIPTION="Perl bindings to the LabOne API of Zurich Instruments"

SLOT="0"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
	sci-electronics/labone
"
DEPEND="
	sci-electronics/labone
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
