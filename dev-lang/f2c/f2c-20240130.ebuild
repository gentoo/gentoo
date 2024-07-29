# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Fortran to C converter"
HOMEPAGE="https://www.netlib.org/f2c"
SRC_URI="
	https://www.netlib.org/f2c/src.tgz -> ${P}.tar.gz
"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/libf2c-20130927-r1"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-20100827-fix-buildsystem.patch
)

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/855593
	# Upstream bug reports are handled via email. I have sent one and
	# will follow up by myself.
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CC
}

src_compile() {
	emake -C src -f makefile.u f2c
}

src_install() {
	dobin src/f2c

	dodoc src/README src/Notice

}
