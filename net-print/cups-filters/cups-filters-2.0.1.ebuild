# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cups filters"
HOMEPAGE="https://wiki.linuxfoundation.org/openprinting/cups-filters"
SRC_URI="https://github.com/OpenPrinting/cups-filters/releases/download/${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+foomatic"

RDEPEND="
	net-print/libcupsfilters
	net-print/libppd
	>=net-print/cups-1.7.3
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

# The tests are composed of:
# - built program
# - test case itself: filter/test.sh
#
# The latter is not wired up, and it becomes immediately evident why.
# Bow to this reality and don't claim we can run anything. As a side
# effect, don't compile in src_test, that which we never use.
RESTRICT="test"

src_configure() {
	local myeconfargs=(
		--enable-imagefilters
		--enable-driverless
		--enable-poppler
		--localstatedir="${EPREFIX}"/var
		--with-fontdir="fonts/conf.avail"
		# These are just probed for the path. Always enable them.
		--with-gs-path="${EPREFIX}"/usr/bin/gs
		--with-mutool-path="${EPREFIX}"/usr/bin/mutool

		$(use_enable foomatic)
	)

	econf "${myeconfargs[@]}"
}
