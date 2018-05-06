# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="https://fukuchi.org/works/qrencode/"
SRC_URI="https://fukuchi.org/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/4"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_with test tests)
		# TODO: figure out how to make SDL check fail as the SDL test
		# program is not useful
	)

	econf "${myconf[@]}"
}

src_test() {
	cd tests || die
	# the configure test checks if reconfiguring works...
	sed -i -e '/configure/d' test_all.sh || die
	sh test_all.sh || die
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
