# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://kernel.kolivas.org/"

IUSE="experimental"

K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="7"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2
detect_version
detect_arch

DEPEND="deblob? ( ${PYTHON_DEPS} )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Con Kolivas' high performance patchset and Gentoo's genpatches for Linux ${K_BRANCH_ID}"

CK_VERSION="1"

CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.xz"

CK_BASE_URL="http://ck.kolivas.org/patches/4.0"
CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_URI}"

UNIPATCH_LIST="${DISTDIR}/${CK_FILE}"
UNIPATCH_STRICTORDER="yes"

pkg_setup() {
	use deblob && python-any-r1_pkg_setup
	kernel-2_pkg_setup
}

src_prepare() {

#-- Comment out CK's EXTRAVERSION in Makefile ---------------------------------

	# linux-info eclass cannot handle recursively expanded variables in Makefile #490328
	sed -i -e 's/\(^EXTRAVERSION :=.*$\)/# \1/' "${S}/Makefile" || die

	kernel-2_src_prepare
}

pkg_postinst() {
	elog "ck-sources previously enabled CPU optimizations by default."
	elog "USE=\"experimental\" is now required to enable this patch."
	elog "this can be set in /etc/portage/package.use (or make.conf)"
}
