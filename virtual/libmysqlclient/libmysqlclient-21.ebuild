# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for MySQL client libraries"
SLOT="0/21"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="dev-db/mysql-connector-c:${SLOT}[static-libs?,${MULTILIB_USEDEP}]"
