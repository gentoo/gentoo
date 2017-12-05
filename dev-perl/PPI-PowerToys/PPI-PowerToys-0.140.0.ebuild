# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="ADAMK"
DIST_VERSION=0.14

inherit perl-module

DESCRIPTION="A handy collection of small PPI-based utilities"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-perl/File-Find-Rule-0.32
	>=dev-perl/File-Find-Rule-Perl-1.10
	>=dev-perl/Test-Script-1.70.0
	>=dev-perl/Probe-Perl-0.01
	dev-perl/PPI
	dev-perl/IPC-Run3
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL/use lib q[.];\nuse inc::Module::Install::DSL/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
