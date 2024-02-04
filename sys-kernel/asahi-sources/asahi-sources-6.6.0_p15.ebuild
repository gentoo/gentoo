# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
#K_WANT_GENPATCHES="base extras experimental"
#K_GENPATCHES_VER="5"
K_NODRYRUN="1"

inherit kernel-2
detect_version
detect_arch

if [[ ${PV} != ${PV/_rc} ]] ; then
	# $PV is expected to be of following form: 6.0_rc5_p1
	MY_TAG="$(ver_cut 6)"
	MY_P="asahi-$(ver_rs 2 - $(ver_cut 1-4))-${MY_TAG}"
else
	# $PV is expected to be of following form: 5.19.0_p1
	MY_TAG="$(ver_cut 5)"
	MY_P="asahi-$(ver_cut 1-2)-${MY_TAG}"
fi

DESCRIPTION="Asahi Linux kernel sources"
HOMEPAGE="https://asahilinux.org"
KERNEL_URI="https://github.com/AsahiLinux/linux/archive/refs/tags/${MY_P}.tar.gz -> ${PN}-${PV}.tar.gz"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

KEYWORDS="~arm64"
IUSE="rust"

DEPEND="
	${DEPEND}
	rust? ( || ( dev-lang/rust[rust-src]
				 dev-lang/rust-bin[rust-src]
			)
			dev-util/bindgen
		)
"

PATCHES=(
		"${FILESDIR}/${P}-enable-speakers-stage1.patch"
		"${FILESDIR}/${P}-enable-speakers-stage2.patch"
)

src_unpack() {
	unpack ${PN}-${PV}.tar.gz
	mv linux-${MY_P} linux-${KV_FULL} || die "Could not move source tree"
}

src_prepare() {
	default
	cd "${WORKDIR}/linux-${KV-FULL}" || die
	# XXX: Genpatches do not yet work with Rust kernels
	#handle_genpatches --set-unipatch-list
	#[[ -n ${UNIPATCH_LIST} || -n ${UNIPATCH_LIST_GENPATCHES} || -n ${UNIPATCH_LIST_DEFAULT} ]] && \
	#	unipatch "${UNIPATCH_LIST_DEFAULT} ${UNIPATCH_LIST_GENPATCHES} ${UNIPATCH_LIST}"
	#unpack_fix_install_path
	#env_setup_xmakeopts
	echo "-${MY_TAG}" > localversion.10-pkgrel || die
	cd "${S}" || die
}

pkg_postinst() {
	einfo "For more information about Asahi Linux please visit ${HOMEPAGE},"
	einfo "or consult the Wiki at https://github.com/AsahiLinux/docs/wiki."
	kernel-2_pkg_postinst
}
