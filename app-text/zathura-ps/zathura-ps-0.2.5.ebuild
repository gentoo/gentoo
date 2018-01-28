# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-ps.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi

DESCRIPTION="PostScript plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND=">=app-text/libspectre-0.2.6:=
	>=app-text/zathura-0.3.8
	dev-libs/glib:2=
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myzathuraconf=(
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		VERBOSE=1
		DESTDIR="${D}"
		PREFIX="${EPREFIX}/usr"
	)
}

src_compile() {
	emake "${myzathuraconf[@]}"
}

src_install() {
	emake "${myzathuraconf[@]}" install
	dodoc AUTHORS
}
