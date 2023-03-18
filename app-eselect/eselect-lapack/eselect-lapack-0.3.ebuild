# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LAPACK module for eselect"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

# Need skel.bash lib
RDEPEND=( ">=app-admin/eselect-1.0.5" )
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="lapack"
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/${MODULE}.eselect-${PVR} ${MODULE}.eselect
	doman "${FILESDIR}"/lapack.eselect.5
}
