# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Provides a generic and flexible way to access and interact with USB HID devices"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~conikost/files/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

RDEPEND="virtual/libusb:0="

DEPEND="${RDEPEND}"

BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-man.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	export OS_LDFLAGS="${LDFLAGS}"

	myeconfargs=(
		"--disable-static"
		"--disable-swig"
		"--disable-warnings"
		"--disable-werror"
		"$(use_with doc doxygen)"
	)

	econf ${myeconfargs[@]}
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r doc/html/.
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
