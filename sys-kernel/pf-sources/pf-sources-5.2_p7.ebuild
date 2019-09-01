# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
ETYPE="sources"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

HOMEPAGE="https://gitlab.com/post-factum/pf-kernel/wikis/README
	https://dev.gentoo.org/~mpagano/genpatches/"

IUSE=""

# No 'experimental' USE flag provided, but we still want to use genpatches
K_EXP_GENPATCHES_NOUSE="1"

# No reason to bump this number unless something new gets included in genpatches,
# in that case we can manually remove the linux kernel patches from genpatches.
K_GENPATCHES_VER="1"

K_NOSETEXTRAVERSION="1"

# Not supported by the Gentoo security crew
K_SECURITY_UNSUPPORTED="1"

K_USEPV="yes"

# We want the very basic patches from gentoo-sources, experimental patch
# is already included in pf-sources
K_WANT_GENPATCHES="base extras"

UNIPATCH_STRICTORDER="yes"

inherit eutils kernel-2
detect_version

DESCRIPTION="Linux kernel fork that includes the pf-kernel patchset and Gentoo's genpatches"

PF_URI="https://github.com/pfactum/pf-kernel/compare/v${PV/_p*/}...v${PV/_p*/}-pf${PV/*_p/}.diff -> ${P}.patch"
SRC_URI="
	${KERNEL_URI}
	${PF_URI}
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${PV/_p*/}-${K_GENPATCHES_VER}.base.tar.xz
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${PV/_p*/}-${K_GENPATCHES_VER}.extras.tar.xz
"

KV_FULL="${PVR}-pf"
S="${WORKDIR}/linux-${KV_FULL}"

PATCHES=(
	"${DISTDIR}/${P}.patch"
)

K_EXTRAEINFO="For more info on pf-sources and details on how to report problems,
see: ${HOMEPAGE}."

pkg_setup(){
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the pf developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_prepare() {
	default
	kernel-2_src_prepare
}

pkg_postinst() {
	kernel-2_pkg_postinst
	optfeature "Userspace KSM helper" sys-process/uksmd
}
