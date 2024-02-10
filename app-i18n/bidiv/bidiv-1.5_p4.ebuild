# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

PATCH_LEVEL=4

DESCRIPTION="A commandline tool displaying logical Hebrew/Arabic"
HOMEPAGE="https://packages.qa.debian.org/b/bidiv.html"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PATCH_LEVEL}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=dev-libs/fribidi-0.19.2-r2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}"

PATCHES=(
	# Use order from "series" file:
	"${WORKDIR}"/debian/patches/try_utf8_fix
	"${WORKDIR}"/debian/patches/makefile
	"${WORKDIR}"/debian/patches/fribidi_019
	"${WORKDIR}"/debian/patches/hyphen_minus
	"${WORKDIR}"/debian/patches/term_size_get
	"${WORKDIR}"/debian/patches/type_fix
	"${WORKDIR}"/debian/patches/cast_fix
)

src_compile() {
	tc-export CC
	emake CC_OPT_FLAGS="-Wall"
}

src_install() {
	dobin bidiv
	doman bidiv.1
	dodoc README WHATSNEW "${WORKDIR}"/debian/changelog
}
