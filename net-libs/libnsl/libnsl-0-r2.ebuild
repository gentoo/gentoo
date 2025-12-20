# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Used only to populate IUSE, bug 643058
inherit multilib-build

DESCRIPTION="Public client interface for NIS(YP) and NIS+ in a IPv6 ready version"
HOMEPAGE="https://github.com/thkukuk/libnsl"

# Fake version to help portage upgrading.

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

DEPEND="elibc_glibc? ( <sys-libs/glibc-2.26 )"
RDEPEND="${DEPEND}"
