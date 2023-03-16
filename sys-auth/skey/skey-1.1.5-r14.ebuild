# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1 toolchain-funcs usr-ldscript

DESCRIPTION="Linux Port of OpenBSD Single-key Password System"
HOMEPAGE="https://web.archive.org/web/20160710152027/http://www.openbsd.org:80/faq/faq8.html#SKey"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~ulm/distfiles/${P}-patches-7.tar.xz"

LICENSE="BSD MIT RSA BEER-WARE"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs"

DEPEND="dev-lang/perl
	sys-libs/cracklib
	virtual/libcrypt:="

RDEPEND="${DEPEND}
	virtual/perl-Time-Local"

BDEPEND="app-arch/xz-utils"

PATCHES=("${WORKDIR}/patch")

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC
	econf --sysconfdir=/etc/skey
}

src_install() {
	into /
	dolib.so libskey.so{.${PV},.${PV%.*},.${PV%%.*},}

	into /usr
	dobin skey skeyinit skeyinfo
	newbin skeyaudit.sh skeyaudit
	newsbin skeyprune.pl skeyprune

	dosym skey /usr/bin/otp-md4
	dosym skey /usr/bin/otp-md5
	dosym skey /usr/bin/otp-sha1

	if use static-libs; then
		dolib.a libskey.a
		gen_usr_ldscript libskey.so
	fi

	doman skey.1 skeyaudit.1 skeyinfo.1 skeyinit.1 skey.3 skeyprune.8

	insinto /usr/include
	doins skey.h

	keepdir /etc/skey

	# only root needs to have access to these files.
	fperms go-rx /etc/skey

	# skeyinit and skeyinfo must be suid root so users
	# can generate their passwords.
	fperms u+s,go-r /usr/bin/skeyinit /usr/bin/skeyinfo

	dodoc README CHANGES

	local DOC_CONTENTS="For an introduction into using s/key authentication,
		take a look at the EXAMPLES section from the skey(1) manpage."
	readme.gentoo_create_doc
}

pkg_postinst() {
	# do not include /etc/skey/skeykeys in the package, as quickpkg
	# may package sensitive information.
	# This also fixes the etc-update issue with #64974.

	# skeyinit will not function if this file is not present.
	touch /etc/skey/skeykeys

	# these permissions are applied by the skey system if missing.
	chmod 0600 /etc/skey/skeykeys

	readme.gentoo_print_elog
}
