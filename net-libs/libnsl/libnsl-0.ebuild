# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Public client interface for NIS(YP) and NIS+ in a IPv6 ready version"
HOMEPAGE="https://github.com/thkukuk/libnsl"

# Fake version to help portage upgrading.

SLOT="0/1"
LICENSE="LGPL-2.1+"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux"

IUSE=""

DEPEND="elibc_glibc? ( <sys-libs/glibc-2.26 )"
RDEPEND="${DEPEND}"
