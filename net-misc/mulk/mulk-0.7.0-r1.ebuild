# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_beta/}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Download agent similar to wget/curl"
HOMEPAGE="http://mulk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="checksum debug metalink"
REQUIRED_USE="checksum? ( metalink )"

DEPEND="
	app-text/htmltidy
	dev-libs/uriparser
	net-misc/curl
	sys-devel/gettext
	virtual/libiconv
	virtual/libintl
	metalink? (
		media-libs/libmetalink
		checksum? ( dev-libs/openssl:= )
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.7.0-musl-locale.patch"
)

src_configure() {
	local checksum=

	if use metalink && use checksum ; then
		checksum="--enable-checksum"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable metalink) \
		"${checksum}"
}

src_install() {
	default

	# Remove static libraries
	find "${ED}" -name '*.a' -delete || die
	# and libtool archives
	find "${ED}" -name '*.la' -delete || die
}
