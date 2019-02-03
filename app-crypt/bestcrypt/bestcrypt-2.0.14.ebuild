# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod toolchain-funcs

MY_PN="BestCrypt"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="http://www.jetico.com/linux/${MY_PN}-${PV}.tar.gz"

LICENSE="bestcrypt"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources
	app-shells/bash"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	HIDDEN_PART README
)

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

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

src_compile() {
	MAKEOPTS="-j1" linux-mod_src_compile \
		CXX="$(tc-getCXX)"
	MAKEOPTS="-j1" emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	linux-mod_src_install

	emake install PREFIX="${ED}" install

	newinitd "${FILESDIR}/bcrypt3" bcrypt
	sed -e '/\(bc_rc6\|bc_serpent\|bc_twofish\)/d' -i "${D}etc/init.d/bcrypt"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	ewarn
	ewarn "The BestCrypt drivers are not free - Please purchace a license from "
	ewarn "http://www.jetico.com/"
	ewarn
	ewarn "Upstream do not support this package any more, it was patched to"
	ewarn "make it built. Use at your own risk!"
	ewarn
}
