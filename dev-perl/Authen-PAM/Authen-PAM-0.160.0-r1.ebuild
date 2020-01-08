# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=NIKIP
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Interface to PAM library"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}/no-dot-inc.patch")
export OPTIMIZE="$CFLAGS"
