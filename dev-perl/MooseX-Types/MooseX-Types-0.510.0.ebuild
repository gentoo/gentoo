# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.51
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Organise your Moose types in libraries"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-perl/Carp-Clan-6
	dev-perl/Module-Runtime
	>=dev-perl/Moose-1.60.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
	dev-perl/Sub-Exporter
	>=dev-perl/Sub-Exporter-ForMethods-0.100.52
	dev-perl/Sub-Install
	>=dev-perl/namespace-autoclean-0.160.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
	)
"
