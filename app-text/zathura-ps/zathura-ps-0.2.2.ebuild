# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/zathura-ps/zathura-ps-0.2.2.ebuild,v 1.9 2014/06/05 09:41:28 ssuominen Exp $

EAPI=5

inherit eutils toolchain-funcs
[[ ${PV} == 9999* ]] && inherit git-2

DESCRIPTION="PostScript plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi
EGIT_REPO_URI="git://git.pwmt.org/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="0"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
else
KEYWORDS=""
fi
IUSE=""

RDEPEND=">=app-text/libspectre-0.2.6:=
	>=app-text/zathura-0.2.7
	dev-libs/glib:2=
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
