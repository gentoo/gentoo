# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="106"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="TuxOnIce + Gentoo patchset sources"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/ http://tuxonice.nigelcunningham.com.au/ https://github.com/NigelCunningham/tuxonice-kernel"

TUXONICE_PV="3.10.95"
TUXONICE_DATE="2016-01-24"

TUXONICE_PATCH="tuxonice-for-linux-${TUXONICE_PV}-${TUXONICE_DATE}.patch.bz2"
TUXONICE_URI="http://tuxonice.nigelcunningham.com.au/downloads/all/${TUXONICE_PATCH}"
UNIPATCH_LIST="${DISTDIR}/${TUXONICE_PATCH}"
UNIPATCH_STRICTORDER="yes"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${TUXONICE_URI}"

KEYWORDS="~amd64 ~x86"
IUSE="experimental"

RDEPEND="${RDEPEND}
	>=sys-apps/tuxonice-userui-1.0
	|| ( >=sys-power/hibernate-script-2.0 sys-power/pm-utils )"

K_EXTRAELOG="If there are issues with this kernel, please direct any queries to the tuxonice-users mailing list:
http://lists.tuxonice.net/mailman/listinfo/tuxonice-users/"
K_SECURITY_UNSUPPORTED="1"
