# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"

CKV="$(ver_cut 1-3)"
K_SECURITY_UNSUPPORTED="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="8"
K_NODRYRUN="1"

RUST_MIN_VER="1.80.0"
RUST_REQ_USE='rust-src,rustfmt'

inherit kernel-2 rust
detect_version
detect_arch

if [[ ${PV} != ${PV/_rc} ]] ; then
	# $PV is expected to be of following form: 6.0_rc5_p1
	MY_TAG="$(ver_cut 6)"
	MY_BASE="$(ver_rs 2 - $(ver_cut 1-4))"
else
	# $PV is expected to be of following form: 5.19.0_p1
	MY_TAG="$(ver_cut 5)"
	if [[ "$(ver_cut 3)" == "0" ]] ; then
		MY_BASE="$(ver_cut 1-2)"
	else
		MY_BASE="$(ver_cut 1-3)"
	fi
fi

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

KEYWORDS="~arm64"

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
