# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Watches a process for termination"
HOMEPAGE="http://www.codepark.org/"
SRC_URI="mirror://gentoo/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
)

multilib_src_configure() {
	tc-export CC
	ECONF_SOURCE="${S}" econf
}
