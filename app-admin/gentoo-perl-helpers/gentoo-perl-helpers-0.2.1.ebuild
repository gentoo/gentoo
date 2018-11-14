# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Introspection and Upgrade Assistance tools for Gentoo Perl"
HOMEPAGE="https://github.com/gentoo-perl/gentoo-perl-helpers"
SRC_URI="
	https://github.com/gentoo-perl/${PN}/releases/download/${PV}/${P}.tar.xz
	mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~kentnl/distfiles/${P}.tar.xz
"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# Assumed System:
# sys-apps/coreutils
# sys-apps/grep
# sys-apps/findutils
# sys-apps/sed
# app-shells/bash
# sys-apps/gawk
# app-arch/tar

RDEPEND="
	app-portage/portage-utils
	sys-apps/portage
"
DEPEND=""

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
