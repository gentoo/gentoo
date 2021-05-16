# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="MaCoPiX (Mascot Constructive Pilot for X) is a desktop mascot application"
HOMEPAGE="http://rosegray.sakura.ne.jp/macopix/index-e.html https://github.com/chimari/MaCoPiX"

BASE_URI="http://rosegray.sakura.ne.jp/macopix"
SRC_URI="${BASE_URI}/${P}.tar.gz"

# NOTE: These mascots are not redistributable on commercial CD-ROM.
# The author granted to use them under Gentoo Linux.
MACOPIX_MASCOTS="
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

for i in ${MACOPIX_MASCOTS} ; do
	SRC_URI+=" ${BASE_URI}/${i}.tar.gz"
done

# program itself is GPL-2, and mascots are free-noncomm
LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnutls nls"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0=
	sys-devel/gettext
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl:0= )
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-CVE-2015-8614.patch
	"${FILESDIR}"/${PN}-3.4.0-Werror.patch
	"${FILESDIR}"/${PN}-3.4.0-fno-common.patch
	"${FILESDIR}"/${PN}-3.4.0-windres.patch
	"${FILESDIR}"/${PN}-3.4.0-openssl-1.1.0.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_with gnutls)
}

src_install() {
	default

	dodoc AUTHORS ChangeLog* NEWS *README*

	# install mascots
	for d in ${MACOPIX_MASCOTS} ; do
		einfo "Installing ${d}..."
		cd "${WORKDIR}/${d}" || die
		insinto /usr/share/"${PN}"
		doins *.mcpx *.menu
		insinto /usr/share/"${PN}"/pixmap
		doins *.png
		docinto "${d}"
		dodoc README.jp
	done
}
