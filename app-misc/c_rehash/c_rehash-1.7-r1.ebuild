# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="c_rehash script from OpenSSL"
HOMEPAGE="http://www.openssl.org/"
SRC_URI="http://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/packages/openssl/openssl-c_rehash.sh?rev=${PV} -> openssl-c_rehash.sh.${PV}"

LICENSE="openssl"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="!<dev-libs/openssl-1.0.2d-r1:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_prepare() {
	SSL_CNF_DIR="/etc/ssl"
	sed \
		-e "/^DIR=/s:=.*:=${EPREFIX}${SSL_CNF_DIR}:" \
		-e "s:SSL_CMD=/usr:SSL_CMD=${EPREFIX}/usr:" \
		"${DISTDIR}"/openssl-c_rehash.sh.${PV} \
		> "${WORKDIR}"/c_rehash || die #416717
}

src_install() {
	dobin "${WORKDIR}"/c_rehash
}
