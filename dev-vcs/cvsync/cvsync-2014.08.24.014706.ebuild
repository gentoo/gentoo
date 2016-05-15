# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/cvsync/cvsync.git"
	inherit git-2
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="portable CVS repository synchronization utility"
HOMEPAGE="https://github.com/cvsync/cvsync"

LICENSE="BSD"
SLOT="0"
IUSE="gcrypt mhash +openssl"
REQUIRED_USE="!openssl? ( ^^ ( gcrypt mhash ) )"

RDEPEND="sys-libs/zlib
	openssl? ( dev-libs/openssl:0= )
	!openssl? (
		gcrypt? ( dev-libs/libgcrypt:0= )
		mhash? ( app-crypt/mhash )
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

maint_pkg_create() {
	cd "${S}"
	local ver=$(date --date="$(git log -n1 --pretty=format:%ci HEAD)" -u "+%Y.%m.%d.%H%M%S")
	local tar="${T}/${PN}-${ver}.tar.xz"
	git archive --prefix "${PN}/" HEAD | xz > "${tar}" || die "creating tar failed"
	einfo "Packaged tar now available:"
	einfo "$(du -b "${tar}")"
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
		maint_pkg_create
	else
		default
	fi
}

_emake() {
	# USE flag settings are enforced by REQUIRED_USE.
	local hash=$(usex openssl openssl $(usex gcrypt gcrypt mhash))

	# Probably want to expand this at some point.
	local host_os="Linux"

	emake \
		CC="$(tc-getCC)" \
		ECHO="echo" \
		TEST="test" \
		INSTALL="install" \
		HASH_TYPE="${hash}" \
		HOST_OS="${host_os}" \
		BINOWN="$(id -u)" \
		BINGRP="$(id -g)" \
		BINDIR="\$(PREFIX)/usr/bin" \
		MANDIR="\$(PREFIX)/usr/share/man" \
		"$@"
}

src_compile() {
	_emake PREFIX="${EPREFIX}"
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	_emake PREFIX="${ED}" install
	dodoc samples/*.conf
}
