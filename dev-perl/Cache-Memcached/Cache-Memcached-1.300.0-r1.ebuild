# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=1.30
inherit perl-module

DESCRIPTION="Perl API for memcached"
HOMEPAGE="http://www.danga.com/memcached/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="dev-perl/String-CRC32"
RDEPEND="${DEPEND}"

SRC_TEST="do"
