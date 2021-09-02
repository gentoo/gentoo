# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib

DESCRIPTION="inih (INI not invented here) simple .INI file parser"
HOMEPAGE="https://github.com/benhoyt/inih"

SRC_URI="https://github.com/benhoyt/inih/archive/r${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

LICENSE="BSD"
SLOT="0"

IUSE="static-libs"

S="${WORKDIR}/inih-r${PV}"

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Ddistro_install=true
		-Dwith_INIReader=true
	)

	meson_src_configure
}

multilib_src_install_all() {
	local DOCS=(
		LICENSE.txt
		README.md
	)
	einstalldocs
}
