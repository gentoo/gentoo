# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="11"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"

inherit kernel-2 unpacker
detect_version
detect_arch

DESCRIPTION="The Zen Kernel Live Sources"
HOMEPAGE="https://github.com/zen-kernel"

# Needed for zstd compression of the patch
BDEPEND="$(unpacker_src_uri_depends)"

ZEN_URI="https://github.com/zen-kernel/zen-kernel/releases/download/v${PV}-zen1/linux-v${PV}-zen1.patch.zst"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${ZEN_URI}"

KEYWORDS="~amd64 ~arm64 ~x86"

UNIPATCH_LIST="${WORKDIR}/linux-v${PV}-zen1.patch"
UNIPATCH_STRICTORDER="yes"

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on oftc"

src_unpack() {
	unpacker "linux-v${PV}-zen1.patch.zst"
	kernel-2_src_unpack
}

pkg_setup() {
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the zen developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_install() {
	rm "${WORKDIR}/linux-v${PV}-zen1.patch" || die
	kernel-2_src_install
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
