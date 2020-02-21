# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="unison module for eselect"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI=""
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.2.3"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="unison"
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${FILESDIR}/${MODULE}.eselect-${PVR}" ${MODULE}.eselect
}
