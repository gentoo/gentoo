# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TURNSTEP
MODULE_VERSION=3.4.2
inherit perl-module

DESCRIPTION="PostgreSQL database driver for the DBI module"

SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="virtual/perl-version
	>=dev-perl/DBI-1.614.0
	dev-db/postgresql:*"
DEPEND="${RDEPEND}"

# testcases require a local database with an
# open password for the postgres user.
SRC_TEST="skip"

src_prepare() {
	postgres_include="$(readlink -f "${EPREFIX}"/usr/include/postgresql)"
	postgres_lib="${postgres_include//include/lib}"
	# Fall-through case is the non-split postgresql
	# The active cases instead get us the matching libdir for the includedir.
	for i in lib lib64 ; do
		if [ -d "${postgres_lib}/${i}" ]; then
			postgres_lib="${postgres_lib}/${i}"
			break
		fi
	done

	# env variables for compilation:
	export POSTGRES_INCLUDE="${postgres_include}"
	export POSTGRES_LIB="${postgres_lib}"
	perl-module_src_prepare
}
