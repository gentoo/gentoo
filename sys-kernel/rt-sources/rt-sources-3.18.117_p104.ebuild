# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64"

HOMEPAGE="https://www.kernel.org/pub/linux/kernel/projects/rt/"

inherit eapi7-ver

CKV="$(ver_cut 1-3)"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"
RT_PATCHSET="${PV/*_p}"

inherit kernel-2
detect_version

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"
RT_FILE="patch-${K_BRANCH_ID}.${KV_PATCH}-rt${RT_PATCHSET}.patch.xz"
RT_URI="mirror://kernel/linux/kernel/projects/rt/${K_BRANCH_ID}/${RT_FILE} \
		mirror://kernel/linux/kernel/projects/rt/${K_BRANCH_ID}/older/${RT_FILE}"

DESCRIPTION="Full Linux ${K_BRANCH_ID} kernel sources with the CONFIG_PREEMPT_RT patch"
SRC_URI="${KERNEL_URI} ${RT_URI}"

KV_FULL="${PVR/_p/-rt}"
S="${WORKDIR}/linux-${KV_FULL}"

UNIPATCH_LIST="${DISTDIR}/${RT_FILE}"
UNIPATCH_STRICTORDER="yes"

PATCHES=(
	"${FILESDIR}"/rt-sources-posix-printf.patch # 627068
)

src_prepare() {
	default

	# 627796
	sed \
		"s/default PREEMPT_NONE/default PREEMPT_RT_FULL/g" \
		-i "${S}/kernel/Kconfig.preempt"
}

pkg_postinst() {
	kernel-2_pkg_postinst
	ewarn
	ewarn "${PN} are *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the RT project developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds."
	ewarn
}

K_EXTRAEINFO="For more info on rt-sources and details on how to report problems, see: \
${HOMEPAGE}."
