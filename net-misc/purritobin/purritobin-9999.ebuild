# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="minimalistic commandline pastebin"
HOMEPAGE="https://bsd.ac"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PurritoBin/PurritoBin.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/PurritoBin/PurritoBin/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/PurritoBin-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="libuv static-libs"

RDEPEND="net-libs/usockets[libuv=,static-libs?]
	libuv? ( >=dev-libs/libuv-1.35.0[static-libs?] )
"
DEPEND="${RDEPEND}
	www-servers/uwebsockets
"

src_prepare() {
	sed -i -e "s:.ifdef:ifdef:g" \
		   -e "s:.else:else:g" \
		   -e "s:.endif:endif:g" \
		   Makefile
	default
}

src_compile() {
	env LDFLAGS="-L/usr/$(get_libdir)" \
		emake $(usex libuv USE_DLIBUV=1 '') \
		$(usex static-libs USE_STATIC=1 '') \
		all
}

src_install() {
	emake prefix="/usr" \
		  DESTDIR="${D}" \
		  install
	einstalldocs
}
