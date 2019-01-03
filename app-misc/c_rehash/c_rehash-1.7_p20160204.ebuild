# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FILE="openssl-c_rehash.sh"
GIT_COMMIT="f79908c1f7004d0abd384451abd923c6b6ba323d"

DESCRIPTION="c_rehash script from OpenSSL"
HOMEPAGE="https://www.openssl.org/ https://git.pld-linux.org/?p=packages/openssl.git https://github.com/pld-linux/openssl/"
SRC_URI="https://git.pld-linux.org/?p=packages/openssl.git;a=blob_plain;f=${MY_FILE};hb=${GIT_COMMIT} -> ${MY_FILE}.${PV}"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="!<dev-libs/openssl-1.0.2d-r1:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_prepare() {
	SSL_CNF_DIR="/etc/ssl"
	sed \
		-e "/^DIR=/s:=.*:=${EPREFIX}${SSL_CNF_DIR}:" \
		-e "s:SSL_CMD=/usr:SSL_CMD=${EPREFIX}/usr:" \
		"${DISTDIR}"/${MY_FILE}.${PV} \
		> "${WORKDIR}"/c_rehash || die #416717

	eapply_user
}

src_install() {
	dobin "${WORKDIR}"/c_rehash
}
