# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C-language BLAS module for eselect"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86 ~x64-macos"
IUSE=""

# Need skel.bash lib
RDEPEND=">=app-admin/eselect-1.0.5"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/cblas.eselect-${PVR} cblas.eselect
	doman "${FILESDIR}"/cblas.eselect.5
}
