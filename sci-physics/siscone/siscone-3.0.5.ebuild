# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Hadron Seedless Infrared-Safe Cone jet algorithm"
HOMEPAGE="https://siscone.hepforge.org/"
SRC_URI="https://siscone.hepforge.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}"/0001-configure-fix-broken-bashisms-resulting-in-logic-fai.patch
)

src_prepare() {
	default

	# The included copy of this macro is from 2008 and totally broken.
	# https://bugs.gentoo.org/890780
	rm m4/ax_prefix_config_h.m4 || die

	# Rebuild after patch to configure.ac, removal of broken macro
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	if use examples; then
		docinto examples
		dodoc examples/*.{cpp,h}
		docinto examples/events
		dodoc examples/events/*.dat
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
