# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs
[[ ${PV} == 9999* ]] && inherit git-2

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="0"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="~amd64 ~x86"
else
KEYWORDS=""
fi
IUSE=""

RDEPEND="!app-text/zathura-pdf-poppler
	>=app-text/mupdf-1.7a:=
	>=app-text/zathura-0.3.1
	media-libs/jbig2dec:=
	media-libs/openjpeg:2=
	virtual/jpeg:0
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	myzathuraconf=(
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		VERBOSE=1
		DESTDIR="${D}"
		MUPDF_LIB="$($(tc-getPKG_CONFIG) --libs mupdf)"
		OPENSSL_INC="$($(tc-getPKG_CONFIG) --cflags mupdf)"
		OPENSSL_LIB=''
	)
}

src_compile() {
	emake "${myzathuraconf[@]}"
}

src_install() {
	emake "${myzathuraconf[@]}" install
	dodoc AUTHORS
}
