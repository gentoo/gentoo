# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="c_rehash script from OpenSSL"
HOMEPAGE="https://www.openssl.org/ https://github.com/pld-linux/openssl/"
SRC_URI="https://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/packages/openssl/openssl-c_rehash.sh?rev=${PV} -> openssl-c_rehash.sh.${PV}"
S="${WORKDIR}"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

RDEPEND="!<dev-libs/openssl-1.0.2d-r1:0"
DEPEND="${RDEPEND}"

src_configure() {
	sed \
		-e "/^DIR=/s:=.*:=${EPREFIX}/etc/ssl:" \
		-e "s:SSL_CMD=/usr:SSL_CMD=${EPREFIX}/usr:" \
		"${DISTDIR}"/openssl-c_rehash.sh.${PV} \
		> "${WORKDIR}"/c_rehash || die #416717
}

src_install() {
	dobin c_rehash
}
