# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"
fi

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="!app-text/zathura-pdf-poppler
	>=app-text/mupdf-1.12.0:=
	>=app-text/zathura-0.3.8
	media-libs/jbig2dec:=
	media-libs/openjpeg:2=
	virtual/jpeg:0
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
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
