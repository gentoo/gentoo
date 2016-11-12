# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=1.302062
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Basic utilities for writing tests"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	!<dev-perl/Test-Tester-0.114.0
	!<dev-perl/Test-use-ok-0.160.0
	!<dev-perl/Log-Dispatch-Config-TestLog-0.20.0
	!<dev-perl/Net-BitTorrent-0.52.0
	!<dev-perl/Test-Able-0.110.0
	!<dev-perl/Test-Aggregate-0.373.0
	!<dev-perl/Test-Alien-0.40.0
	!<dev-perl/Test-Builder-Clutch-0.70.0
	!<dev-perl/Test-Clustericious-Cluster-0.300.0
	!<dev-perl/Test-Dist-VersionSync-1.1.4
	!<dev-perl/Test-Exception-0.420.0
	!<dev-perl/Test-Flatten-0.110.0
	!<dev-perl/Test-Group-0.200.0
	!<dev-perl/Test-Modern-0.12.0
	!<dev-perl/Test-More-Prefix-0.5.0
	!<dev-perl/Test-ParallelSubtest-0.50.0
	!<dev-perl/Test-Pretty-0.320.0
	!<dev-perl/Test-SharedFork-0.340.0
	!<dev-perl/Test-Wrapper-0.3.0
	!<dev-perl/Test-UseAllModules-0.140.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	>=virtual/perl-Scalar-List-Utils-1.130.0
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
