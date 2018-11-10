# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# To recreate this tarball, just grab latest rpm5 release:
#	http://rpm5.org/files/rpm/
# The files are in tools/
# Or see $FILESDIR/update.sh

EAPI="5"

inherit toolchain-funcs eutils

# See #653906 for the need to reversion.
MY_PV=${PV#0.}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="standalone debugedit taken from rpm"
HOMEPAGE="http://www.rpm5.org/"
SRC_URI="https://dev.gentoo.org/~swegener/distfiles/${MY_P}.tar.bz2
	https://dev.gentoo.org/~vapier/dist/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-libs/popt
	dev-libs/elfutils
	dev-libs/beecrypt"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.3.5-DWARF-4.patch #400663
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin debugedit
}
