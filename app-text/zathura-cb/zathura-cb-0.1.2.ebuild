# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-cb.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="amd64 ~arm x86"
	SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi

DESCRIPTION="Comic book plug-in for zathura with 7zip, rar, tar and zip support"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

COMMON_DEPEND=">=app-text/zathura-0.2.7
	dev-libs/glib:2=
	app-arch/libarchive:=
	x11-libs/cairo:="
RDEPEND="${COMMON_DEPEND}
	app-arch/p7zip
	app-arch/tar
	app-arch/unrar
	app-arch/unzip"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_configure() {
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
