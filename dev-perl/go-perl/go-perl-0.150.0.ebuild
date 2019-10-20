# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_VERSION=0.15
DIST_AUTHOR="CMUNGALL"
DEB_PATCH_VER="7"

inherit perl-module

DESCRIPTION="GO::Parser parses all GO files formats and types"
SRC_URI="${SRC_URI}
	mirror://debian/pool/main/libg/libgo-perl/lib${PN}_${DIST_VERSION}-${DEB_PATCH_VER}.debian.tar.xz
"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-perl/Data-Stag-0.11"
BDEPEND="${RDEPEND}"
DEPEND=""

src_prepare() {
	for patch in $(< "${WORKDIR}"/debian/patches/series); do
		eapply "${WORKDIR}"/debian/patches/${patch}
	done

	perl-module_src_prepare
}
