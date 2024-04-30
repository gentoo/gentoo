# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOUSEPR="yes"
K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"
K_BASE_VER="6.8"
K_EXP_GENPATCHES_NOUSE="1"
K_FROM_GIT="yes"
K_NODRYRUN="yes"
ETYPE="sources"

inherit kernel-2
detect_version

DESCRIPTION="Full sources including the sched_ext patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="https://github.com/sched-ext/sched_ext"
SRC_URI="
	https://github.com/sched-ext/scx-kernel-releases/archive/refs/tags/v${PV}-scx2.tar.gz -> linux-${KV_FULL}.tar.gz
	${GENPATCHES_URL}
"

KEYWORDS="~amd64 arm64 ~x86"

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the sched_ext developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	kernel-2_pkg_setup
}

universal_unpack() {
	unpack linux-${KV_FULL}.tar.gz

	mv "${WORKDIR}"/scx-kernel-releases-${PV}-scx2 "${WORKDIR}"/linux-${KV_FULL} || die
}

src_prepare() {
	default
	kernel-2_src_prepare
}

pkg_postinst() {
	kernel-2_pkg_postinst
}
