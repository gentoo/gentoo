# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Introspection and Upgrade Assistance tools for Gentoo Perl"
HOMEPAGE="https://github.com/gentoo-perl/gentoo-perl-helpers"
SRC_URI="
	https://github.com/gentoo-perl/${PN}/releases/download/${PV}/${P}.tar.xz
	mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~kentnl/distfiles/${P}.tar.xz
"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

# Assumed System:
# sys-apps/coreutils
# sys-apps/grep
# sys-apps/sed
# app-shells/bash
# sys-apps/gawk
# app-arch/tar

# multiple --quiet, --format and anti-slot support)
RDEPEND="
	>=app-portage/portage-utils-0.80_pre20190620
"
BDEPEND="app-arch/xz-utils[extra-filters(+)]"

src_prepare() {
	sed -i -e "s^@@LIBDIR@@^${EPREFIX}/usr/lib/gentoo-perl-helpers^g" 		\
		   -e "s^@@LIBEXECDIR@@^${EPREFIX}/usr/libexec/gentoo-perl-helpers^g" \
		   "${S}/bin/gentoo-perl"			\
		   "${S}/lib/core-functions.sh"		\
		   || die "Can't patch bin/gentoo-perl"
	default
}

src_compile() { :; }

src_install() {
	exeinto /usr/bin
	doexe "${S}/bin/"*

	exeinto /usr/libexec/gentoo-perl-helpers
	doexe "${S}/libexec/"*

	insinto /usr/lib/gentoo-perl-helpers
	doins -r "${S}/lib/"*

	dodoc "${S}/README.mkdn" "${S}/Changes"
}
