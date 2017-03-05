# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="ALIAN"
MODULE_VERSION=3.2
inherit perl-module

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=net-fs/samba-4.2[client]"
RDEPEND="${DEPEND}"

# tests are not designed to work on a non-developer system.
RESTRICT=test
