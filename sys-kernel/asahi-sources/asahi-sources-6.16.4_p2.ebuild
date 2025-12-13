# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"

CKV="$(ver_cut 1-3)"
K_SECURITY_UNSUPPORTED="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="5"
K_NODRYRUN="1"

RUST_MIN_VER="1.85.0"
RUST_REQ_USE='rust-src,rustfmt'

inherit kernel-2 rust
detect_version
detect_arch

MY_BASE=${PV%_p*}
MY_TAG=${PV#*_p}

EXTRAVERSION="-asahi-${MY_TAG}"

ASAHI_TAG="asahi-${MY_BASE}-${MY_TAG}"

DESCRIPTION="Asahi Linux kernel sources"
HOMEPAGE="https://asahilinux.org"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	https://github.com/AsahiLinux/linux/compare/v${MY_BASE}...${ASAHI_TAG}.diff
		-> linux-${ASAHI_TAG}.diff
"
KV_FULL="${PVR/_p/-asahi-}"
S="${WORKDIR}/linux-${KV_FULL}"

KEYWORDS="arm64"

DEPEND="
	${DEPEND}
	dev-util/bindgen
"

UNIPATCH_STRICTORDER="yes"
UNIPATCH_LIST="
	${FILESDIR}/asahi-6.8-config-gentoo-Drop-RANDSTRUCT-from-GENTOO_KERNEL_SEL.patch
	${DISTDIR}/linux-${ASAHI_TAG}.diff
"

src_prepare() {
	default

	# remove asahi upstream set localversion, use EXTRAVERSION instead
	rm localversion.05-asahi
}

pkg_postinst() {
	einfo "For more information about Asahi Linux please visit ${HOMEPAGE},"
	einfo "or consult the Wiki at https://github.com/AsahiLinux/docs/wiki."
	kernel-2_pkg_postinst
}
