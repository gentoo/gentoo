# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="8"
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://kernel.kolivas.org/"
IUSE="experimental"

DESCRIPTION="Gentoo's genpatches for Linux ${K_BRANCH_ID}, with Con Kolivas' MuQSS process scheduler."

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

CK_EXTRAVERSION="ck1"
CK_URI="http://ck.kolivas.org/patches/5.0/${K_BRANCH_ID}/${K_BRANCH_ID}-${CK_EXTRAVERSION}/patch-${K_BRANCH_ID}-${CK_EXTRAVERSION}.xz"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_URI}"

UNIPATCH_LIST="${DISTDIR}/patch-${K_BRANCH_ID}-${CK_EXTRAVERSION}.xz
	"${FILESDIR}"/ck-5.4-revert-version.patch"
UNIPATCH_STRICTORDER="yes"
