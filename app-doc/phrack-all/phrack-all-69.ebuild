# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}${PV}
DESCRIPTION="Hacker magazine by the community, for the community (all issues)"
HOMEPAGE="http://www.phrack.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=$(printf '~app-doc/phrack-%02i ' {1..69})
