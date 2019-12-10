# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://kernel.kolivas.org/"

IUSE="experimental"

K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="3"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2
detect_version
detect_arch

DEPEND="deblob? ( ${PYTHON_DEPS} )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Gentoo's genpatches for Linux ${K_BRANCH_ID}, with Con Kolivas' MuQSS process scheduler."

CK_EXTRAVERSION="ck1"
CK_URI="http://ck.kolivas.org/patches/5.0/${K_BRANCH_ID}/${K_BRANCH_ID}-${CK_EXTRAVERSION}/patch-${K_BRANCH_ID}-${CK_EXTRAVERSION}.xz"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_URI}"

UNIPATCH_LIST="${DISTDIR}/patch-${K_BRANCH_ID}-${CK_EXTRAVERSION}.xz"
UNIPATCH_STRICTORDER="yes"

pkg_setup() {
	use deblob && python-any-r1_pkg_setup
	kernel-2_pkg_setup
}
