# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KASEI
MODULE_VERSION=0.34
inherit perl-module

DESCRIPTION="Automated accessor generation"

SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Sub-Name"
DEPEND="${RDEPEND}"

SRC_TEST="do"
