# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="IRSIM is a \"switch-level\" simulator"
HOMEPAGE="http://opencircuitdesign.com/irsim/"
SRC_URI="http://opencircuitdesign.com/irsim/archive/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/tcl:=
	dev-lang/tk:=
"
DEPEND="${RDEPEND}"
BDEPEND="app-shells/tcsh"

PATCHES=(
	"${FILESDIR}"/${PN}-9.7.72-ldflags.patch
	"${FILESDIR}"/${PN}-9.7.79-datadir.patch
)

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	cd scripts || die
	econf
}

pkg_postinst() {
	einfo
	einfo "You will probably need to add to your ~/.Xdefaults"
	einfo "the following line:"
	einfo "irsim.background: black"
	einfo
	einfo "This is needed because Gentoo from default sets a"
	einfo "grey background which makes impossible to see the"
	einfo "simulation (white line on light gray background)."
	einfo
}
