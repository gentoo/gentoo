# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-2.0.4.ebuild,v 1.1 2014/07/06 19:07:36 alonbl Exp $

EAPI="5"

inherit eutils linux-mod toolchain-funcs versionator

MY_PN="bcrypt"
MY_PV="$(replace_version_separator 2 -)"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="http://www.jetico.com/linux/BestCrypt-${MY_PV}.tar.gz"

LICENSE="bestcrypt"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${MY_PV}"

pkg_setup() {
	CONFIG_CHECK="MODULES"
	linux-mod_pkg_setup

	MODULE_NAMES="bestcrypt(block::kernel/kmod)
		bc_3des(crypto::kernel/kmod/crypto/algs/3des)
		bc_bf128(crypto::kernel/kmod/crypto/algs/bf128)
		bc_bf448(crypto::kernel/kmod/crypto/algs/bf448)
		bc_blowfish(crypto::kernel/kmod/crypto/algs/blowfish)
		bc_cast(crypto::kernel/kmod/crypto/algs/cast)
		bc_des(crypto::kernel/kmod/crypto/algs/des)
		bc_gost(crypto::kernel/kmod/crypto/algs/gost)
		bc_idea(crypto::kernel/kmod/crypto/algs/idea)
		bc_rijn(crypto::kernel/kmod/crypto/algs/rijn)"
	BUILD_TARGETS="module"
	BUILD_PARAMS=" \
		BC_KERNEL_DIR=\"${KERNEL_DIR}\""
}

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
}

src_compile() {
	MAKEOPTS="-j1" linux-mod_src_compile
	MAKEOPTS="-j1" emake \
		CFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	linux-mod_src_install

	emake install PREFIX="${ED}" install

	newinitd "${FILESDIR}/bcrypt3" bcrypt
	sed -e '/\(bc_rc6\|bc_serpent\|bc_twofish\)/d' -i "${D}etc/init.d/bcrypt"
	dodoc HIDDEN_PART README
}

pkg_postinst() {
	ewarn
	ewarn "The BestCrypt drivers are not free - Please purchace a license from "
	ewarn "http://www.jetico.com/"
	ewarn

	linux-mod_pkg_postinst
}
