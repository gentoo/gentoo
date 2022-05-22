# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests not wired up to meson and don't seem to be intended for downstream use yet
# e.g. hardcoding gcc, just a shell script

inherit meson-multilib

DESCRIPTION="inih (INI not invented here) simple .INI file parser"
HOMEPAGE="https://github.com/benhoyt/inih"

SRC_URI="https://github.com/benhoyt/inih/archive/r${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86"
S="${WORKDIR}/inih-r${PV}"

LICENSE="BSD"
SLOT="0"

DOCS=( README.md )

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=shared
		-Ddistro_install=true
		-Dwith_INIReader=true
	)

	meson_src_configure
}
