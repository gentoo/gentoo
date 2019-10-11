# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.987
inherit perl-module

DESCRIPTION="A sophisticated exporter for custom-built routines"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Sub-Install-0.920.0
	>=dev-perl/Data-OptList-0.100.0
	>=dev-perl/Params-Util-0.140.0
"
DEPEND="${RDEPEND}"

SRC_TEST=do
