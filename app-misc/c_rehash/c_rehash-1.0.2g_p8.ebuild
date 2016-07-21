# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P="openssl-${PV/_p/-}"

DESCRIPTION="c_rehash script written in POSIX shell for OpenSSL"
HOMEPAGE="https://www.openssl.org/ https://github.com/pld-linux/openssl/"
SRC_URI="https://github.com/pld-linux/openssl/archive/auto/th/${MY_P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl:0 )
"

S="${WORKDIR}/openssl-auto-th-${MY_P}"

src_prepare() {
	SSL_CNF_DIR="/etc/ssl"
	sed -i \
		-e "/^DIR=/s:=.*:=${EPREFIX}${SSL_CNF_DIR}:" \
		-e '1iOPENSSL=openssl' \
		openssl-c_rehash.sh || die #416717
}

src_install() {
	newbin openssl-c_rehash.sh c_rehash
}
