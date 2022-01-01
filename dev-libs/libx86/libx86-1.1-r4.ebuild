# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A hardware-independent library for executing real-mode x86 code"
HOMEPAGE="https://www.codon.org.uk/~mjg59/libx86/"
SRC_URI="https://www.codon.org.uk/~mjg59/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="static-libs"

src_prepare() {
	# fix compile failure with linux-headers-2.6.26, bug 235599
	eapply -p0 "${FILESDIR}/${PN}-0.99-ifmask.patch"
	# Patch for bugs #236888 and #456648
	eapply -p0 "${FILESDIR}/${P}-makefile.patch"
	# Wider arch compatibility, bug #579682
	eapply -p2 "${FILESDIR}/${P}-x86emu.patch"

	eapply_user
}

src_configure() {
	tc-export CC AR
	append-flags -fno-delete-null-pointer-checks #523276
}

src_compile() {
	local ARGS
	use x86 || ARGS="BACKEND=x86emu"
	emake ${ARGS} LIBRARY=shared shared
	if use static-libs; then
		emake ${ARGS} objclean
		emake ${ARGS} LIBRARY=static static
	fi
}

src_install() {
	local install_static;
	use static-libs && install_static='install-static'
	emake \
		LIBDIR="/usr/$(get_libdir)" \
		DESTDIR="${D}" \
		install-header install-shared ${install_static}
}
