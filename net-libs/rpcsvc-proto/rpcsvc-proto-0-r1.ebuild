# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="rpcsvc protocol definitions from glibc"
HOMEPAGE="https://github.com/thkukuk/rpcsvc-proto"

# Fake version to help portage upgrading.

LICENSE="LGPL-2.1+ BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

DEPEND="elibc_glibc? ( sys-libs/glibc[rpc(-)] )"
RDEPEND="${DEPEND}"
