# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PromyLOPh/pianobar.git"
else
	SRC_URI="https://6xq.net/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A console-based replacement for Pandora's flash player"
HOMEPAGE="https://6xq.net/pianobar/"

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/json-c:=
	dev-libs/libgcrypt:0=
	media-libs/libao
	>=media-video/ffmpeg-3.3:0=
	net-misc/curl
"
DEPEND="${RDEPEND}"

src_compile() {
	append-cflags -std=c99
	tc-export AR CC
	emake V=1 DYNLINK=1
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR=/usr/$(get_libdir) DYNLINK=1 install
	dodoc ChangeLog README.md

	rm "${D}"/usr/lib*/*.a || die

	docinto contrib
	dodoc -r contrib/{config-example,*.sh,eventcmd-examples}
	docompress -x /usr/share/doc/${PF}/contrib
}
