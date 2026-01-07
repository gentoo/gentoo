# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}${PV}
DESCRIPTION="Hacker magazine by the community, for the community (all issues)"
HOMEPAGE="http://www.phrack.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE=""

printf -v RDEPEND '~app-doc/phrack-%02i ' {1..71}
