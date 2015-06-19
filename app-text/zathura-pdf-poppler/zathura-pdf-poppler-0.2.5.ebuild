# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/zathura-pdf-poppler/zathura-pdf-poppler-0.2.5.ebuild,v 1.2 2014/06/05 09:41:03 ssuominen Exp $

EAPI=5

inherit eutils toolchain-funcs
[[ ${PV} == 9999* ]] && inherit git-2

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi
EGIT_REPO_URI="git://git.pwmt.org/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="0"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="amd64 arm x86"
else
KEYWORDS=""
fi
IUSE=""

RDEPEND="app-text/poppler:=[cairo]
	>=app-text/zathura-0.2.7
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	myzathuraconf=(
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		VERBOSE=1
		DESTDIR="${D}"
	)
}

src_compile() {
	emake "${myzathuraconf[@]}"
}

src_install() {
	emake "${myzathuraconf[@]}" install
	dodoc AUTHORS
}
