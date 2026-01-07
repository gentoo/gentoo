# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A documentation metadata library"
HOMEPAGE="https://rarian.freedesktop.org/"
SRC_URI="https://gitlab.freedesktop.org/rarian/rarian/-/releases/${PV}/downloads/assets/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/libxslt
	dev-libs/tinyxml2:=
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-libs/check-0.9.6 )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/util-linux
"

src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}"/var
		$(use_with test check)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	keepdir /var/lib/rarian
	find "${ED}" -name '*.la' -delete || die
}
