# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ROSCH
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Interpret and act on wait() status values"

SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86"

RDEPEND="
	dev-perl/IPC-Signal
"
BDEPEND="${RDEPEND}
"
