# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Intel Montara 855GM CRT out auxiliary driver"
HOMEPAGE="http://i855crt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXv"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-i915support.diff
	"${FILESDIR}"/${PN}-0.4-makefile.patch
)

src_prepare() {
	default

	# upstream ships it with the binary, we want to make sure we compile it
	emake clean
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin i855crt
	insinto /etc
	doins i855crt.conf
	einstalldocs
}
