# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TJMATHER
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Regular expressions for XML tokens"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/XML-Parser-2.290.0
"
BDEPEND="${RDEPEND}
"
