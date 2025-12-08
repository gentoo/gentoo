# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Deconstructed Dynamic C Library Loading"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	dev-perl/Module-Build
"
