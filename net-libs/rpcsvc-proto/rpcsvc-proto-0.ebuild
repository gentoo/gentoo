# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="rpcsvc protocol definitions from glibc"
HOMEPAGE="https://github.com/thkukuk/rpcsvc-proto"

# Fake version to help portage upgrading.

SLOT="0"
LICENSE="LGPL-2.1+ BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="elibc_glibc? ( sys-libs/glibc[rpc(-)] )"
RDEPEND="${DEPEND}"
