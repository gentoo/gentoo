# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	"${FILESDIR}"/${PN}-0.2.17-configure.patch
	"${FILESDIR}"/${PN}-0.2.17-man.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local CONFIG_SHELL="$(type -P bash)"
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
