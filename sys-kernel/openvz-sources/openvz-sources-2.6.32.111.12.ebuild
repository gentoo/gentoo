# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator

OVZ_KV="$(get_version_component_range 4).$(get_version_component_range 5)"

CKV=$(get_version_component_range 1-3)
OKV=${OKV:-${CKV}}
EXTRAVERSION=-${PN/-*}-${OVZ_KV}
ETYPE="sources"
KV_FULL=${CKV}${EXTRAVERSION}
if [[ ${PR} != "r0" ]]; then
	KV_FULL+=-${PR}
	EXTRAVERSION+=-${PR}
fi
S=${WORKDIR}/linux-${KV_FULL}

# ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH} should succeed.
KV_MAJOR=$(get_version_component_range 1 ${OKV})
KV_MINOR=$(get_version_component_range 2 ${OKV})
KV_PATCH=$(get_version_component_range 3 ${OKV})

KERNEL_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.${KV_MINOR}/linux-${OKV}.tar.xz"

K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE=0
inherit kernel-2
#detect_version

KEYWORDS="amd64 ~ppc64 ~sparc ~x86"
IUSE=""

DESCRIPTION="Kernel sources with OpenVZ patchset"
HOMEPAGE="http://www.openvz.org"
SRC_URI="${KERNEL_URI} ${ARCH_URI}
	http://download.openvz.org/kernel/branches/rhel6-${CKV}/042stab${OVZ_KV}/patches/patch-042stab${OVZ_KV}-combined.gz"

UNIPATCH_STRICTORDER=1
UNIPATCH_LIST="${DISTDIR}/patch-042stab${OVZ_KV}-combined.gz"

K_EXTRAEINFO="This openvz kernel uses RHEL6 patchset instead of vanilla kernel.
This patchset considered to be more stable and security supported by upstream,
but for us RHEL6 patchset is very fragile and fails to build in many
configurations so if you have problems use config files from openvz team
http://wiki.openvz.org/Download/kernel/rhel6/042stab${OVZ_KV}"
