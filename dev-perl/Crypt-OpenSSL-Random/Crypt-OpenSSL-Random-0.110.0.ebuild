# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RURBAN
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="OpenSSL/LibreSSL pseudo-random number generator access"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="${RDEPEND}"

export OPTIMIZE="${CFLAGS}"
mydoc="ToDo"

src_test() {
	perl_rm_files t/z_{kwalitee,manifest,meta,perl-minimum_version}.t \
		t/z_pod-coverage.t t/z_pod.t
	perl-module_src_test
}
