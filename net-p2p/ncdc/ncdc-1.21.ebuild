# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="ncurses directconnect client"
HOMEPAGE="https://dev.yorhel.nl/ncdc"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://g.blicky.net/ncdc.git"
else
	SRC_URI="https://dev.yorhel.nl/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="geoip"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/glib:2
	net-libs/gnutls:=
	sys-libs/ncurses:0=[unicode]
	sys-libs/zlib:=
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/makeheaders
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.21-tinfo.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with geoip)
	)
	if [[ "${PV}" == *9999 ]] ; then
		myeconfargs+=( --enable-git-version )
	fi
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}
