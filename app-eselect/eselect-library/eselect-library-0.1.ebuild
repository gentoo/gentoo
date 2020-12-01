# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="runtime library switching module for eselect"
HOMEPAGE="https://github.com/bsd-ac/gentoo-blas-lapack"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="app-admin/eselect"

S="${WORKDIR}"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="library"
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/${MODULE}.eselect-${PVR} ${MODULE}.eselect
}
