# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/jariruusu.asc"
inherit linux-mod-r1 verify-sig

MY_P="${PN/aes/AES}-v${PV}"

DESCRIPTION="Linux kernel module to encrypt disk partitions with AES cipher"
HOMEPAGE="https://sourceforge.net/projects/loop-aes/"
SRC_URI="
	https://loop-aes.sourceforge.net/loop-AES/${MY_P}.tar.bz2
	verify-sig? (
		https://loop-aes.sourceforge.net/loop-AES/${MY_P}.tar.bz2.sign
			-> ${MY_P}.tar.bz2.sig
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE="cpu_flags_x86_aes extra-ciphers keyscrub cpu_flags_x86_padlock"

DEPEND="app-crypt/loop-aes-losetup"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-jariruusu )"

PATCHES=(
	"${FILESDIR}"/loop-aes-3.7w-build-initrd_explicit-losetup.patch
	"${FILESDIR}"/loop-aes-3.8c-build-initrd_nvme.patch
)

pkg_setup() {
	linux-mod-r1_pkg_setup

	CONFIG_CHECK="!BLK_DEV_LOOP"
}

src_compile() {
	local modlist=( loop=block::tmp-d-kbuild:all )
	local modargs=( VAR="${KV_OUT_DIR}"
		LINUX_SOURCE="${KERNEL_DIR}"
		KBUILD_OUTPUT="${KBUILD_OUTPUT}"
		USE_KBUILD=y MODINST=n RUNDM=n )

	if use extra-ciphers; then
		modlist+=(
			loop_blowfish=block::tmp-d-kbuild:all
			loop_serpent=block::tmp-d-kbuild:all
			loop_twofish=block::tmp-d-kbuild:all )
		modargs+=( EXTRA_CIPHERS=y )
	fi

	use cpu_flags_x86_aes && modargs+=( INTELAES=y )
	use keyscrub && modargs+=( KEYSCRUB=y )
	use cpu_flags_x86_padlock && modargs+=( PADLOCK=y )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	dodoc README
	dodoc ChangeLog
	dobin loop-aes-keygen
	doman loop-aes-keygen.1

	into /
	dosbin build-initrd.sh
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	einfo
	einfo "For more instructions take a look at examples in README at:"
	einfo "'${EPREFIX}/usr/share/doc/${PF}'"
	einfo
}
