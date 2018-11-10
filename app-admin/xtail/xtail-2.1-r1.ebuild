# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tail multiple logfiles at once, even if rotated"
HOMEPAGE="http://www.unicom.com/sw/xtail/"
SRC_URI="
	http://www.unicom.com/sw/xtail/${P}.tar.gz
	http://www.unicom.com/files/20120219-patch-aalto.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="app-arch/unzip"

PATCHES=(
	"${WORKDIR}"/0001-Use-ISO8601-Fix-Gcc-header-Use-C-c.patch
	"${WORKDIR}"/0001-xtail.1-remove-SIGQUIT.patch
	"${WORKDIR}"/xtail_2.1-5-debian-local-changes.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin xtail
	doman xtail.1
	dodoc README
	newdoc ../README README.patches
}
