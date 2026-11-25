# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit flag-o-matic toolchain-funcs verify-sig

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/purplesym/pianobar.git"
else
	SRC_URI="
		https://6xq.net/${PN}/${P}.tar.bz2
		verify-sig? ( https://6xq.net/${PN}/${P}.tar.bz2.asc )
	"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Console-based replacement for Pandora's flash player"
HOMEPAGE="https://6xq.net/pianobar/"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libgcrypt:=
	media-libs/libao
	>=media-video/ffmpeg-6:=
	net-misc/curl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-ldbraun )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ldbraun.asc

src_compile() {
	append-cflags -std=c99
	tc-export AR CC PKG_CONFIG
	emake V=1 DYNLINK=1
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" DYNLINK=1 install
	dodoc ChangeLog README.rst

	find "${D}" -name '*.a' -delete || die

	docinto contrib
	dodoc -r contrib/{config-example,*.sh,eventcmd-examples}
	docompress -x /usr/share/doc/${PF}/contrib
}
