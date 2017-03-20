# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="MaCoPiX (Mascot Constructive Pilot for X) is a desktop mascot application"
HOMEPAGE="http://rosegray.sakura.ne.jp/macopix/index-e.html"

BASE_URI="http://rosegray.sakura.ne.jp/macopix"
SRC_URI="${BASE_URI}/${P}.tar.bz2"

# NOTE: These mascots are not redistributable on commercial CD-ROM.
# The author granted to use them under Gentoo Linux.
MY_MASCOTS="
	macopix-mascot-HxB-euc-ja-0.30
	macopix-mascot-marimite-euc-ja-2.20
	macopix-mascot-cosmos-euc-ja-1.02
	macopix-mascot-mizuiro-euc-ja-1.02
	macopix-mascot-pia2-euc-ja-1.02
	macopix-mascot-tsukihime-euc-ja-1.02
	macopix-mascot-triangle_heart-euc-ja-1.02
	macopix-mascot-comic_party-euc-ja-1.02
	macopix-mascot-kanon-euc-ja-1.02
	macopix-mascot-one-euc-ja-1.02
"

for i in ${MY_MASCOTS} ; do
	SRC_URI+=" ${BASE_URI}/${i}.tar.gz"
done

# programme itself is GPL-2, and mascots are free-noncomm
LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="gnutls nls"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0=
	sys-devel/gettext
	x11-libs/gtk+:2
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl:0= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-windres.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-libs -lX11

	econf $(use_with gnutls)
}

src_install() {
	default

	dodoc AUTHORS ChangeLog* NEWS *README*

	# install mascots
	for d in ${MY_MASCOTS} ; do
		einfo "Installing ${d}..."
		cd "${WORKDIR}/${d}" || die
		insinto /usr/share/"${PN}"
		for i in *.mcpx *.menu ; do
			doins "$i" || die
		done
		insinto /usr/share/"${PN}"/pixmap
		for i in *.png ; do
			doins "$i"
		done
		docinto "${d}"
		dodoc README.jp
	done
}
