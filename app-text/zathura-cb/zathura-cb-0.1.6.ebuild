# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs readme.gentoo-r1
[[ ${PV} == 9999* ]] && inherit git-2

DESCRIPTION="Comic book plug-in for zathura with 7zip, rar, tar and zip support"
HOMEPAGE="http://pwmt.org/projects/zathura/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="0"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="amd64 arm x86"
fi
IUSE=""

RDEPEND=">=app-text/zathura-0.3.1
	dev-libs/glib:2=
	app-arch/libarchive:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:="
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
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

FORCE_PRINT_ELOG=1
DOC_CONTENTS="Consider installing app-arch/p7zip app-arch/tar app-arch/unrar
app-arch/unzip for additional file support."
