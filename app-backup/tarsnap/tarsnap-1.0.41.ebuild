# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tarsnap.asc
inherit toolchain-funcs shell-completion verify-sig

DESCRIPTION="Online backups for the truly paranoid"
HOMEPAGE="https://www.tarsnap.com/"
SRC_URI="
	https://www.tarsnap.com/download/${PN}-autoconf-${PV}.tgz
	verify-sig? ( https://www.tarsnap.com/download/${PN}-sigs-${PV}.asc )
"
S="${WORKDIR}"/${PN}-autoconf-${PV}

LICENSE="tarsnap BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="acl bzip2 lzma xattr"
# The tarsnap license allows redistribution only without modification.
# Commented out because patches apply only to files with a free license.
#RESTRICT="bindist"

RDEPEND="
	app-arch/bzip2
	dev-libs/openssl:=
	sys-fs/e2fsprogs
	virtual/zlib:=
	acl? ( sys-apps/acl )
	lzma? ( app-arch/xz-utils )
	xattr? ( sys-apps/attr )
"
# Required for "magic.h"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-tarsnap )"

QA_CONFIG_IMPL_DECL_SKIP=(
	# false positive due to outdated autoconf, bug #900124
	# release tarballs don't contain configure.ac!!!
	makedev
)

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			${PN}-sigs-${PV}.asc \
			openssl-dgst \
			${PN}-autoconf-${PV}.tgz
		cd "${WORKDIR}" || die
	fi

	default
}

src_configure() {
	local myeconfargs=(
		$(use_enable xattr)
		$(use_enable acl)
		# The bundled libarchive (ancient copy) always builds
		# the bzip2 bits.
		--with-bz2lib
		--without-lzmadec
		$(use_with lzma)
		--with-bash-completion-dir="$(get_bashcompdir)"
		--with-zsh-completion-dir="$(get_zshcompdir)"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_test() {
	emake test
}
