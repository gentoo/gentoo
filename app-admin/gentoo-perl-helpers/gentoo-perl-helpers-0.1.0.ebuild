# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Introspection and Upgrade Assistance tools for Gentoo Perl"
HOMEPAGE="https://github.com/gentoo-perl/gentoo-perl-helpers"
SRC_URI="https://github.com/gentoo-perl/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Assumed System:
# sys-apps/coreutils
# sys-apps/grep
# sys-apps/findutils
# sys-apps/sed
# app-shells/bash

RDEPEND="
	app-portage/portage-utils
	sys-apps/portage
"
DEPEND=""

S="${WORKDIR}"
src_prepare() {
	sed -i -e "s^@@LIBDIR@@^${EPREFIX}/usr/lib/gentoo-perl-helpers^g" 		\
		   -e "s^@@LIBEXECDIR@@^${EPREFIX}/usr/libexec/gentoo-perl-helpers^g" \
		   "${S}/bin/gentoo-perl"			|| die "Can't patch bin/gentoo-perl"
	default
}
src_compile() { :; }
src_install() {
	exeinto /usr/bin
	doexe "${S}/bin/"*

	exeinto /usr/libexec/gentoo-perl-helpers
	doexe "${S}/libexec/"*

	insinto /usr/lib/gentoo-perl-helpers
	doins "${S}/lib/"*

	dodoc "${S}/README.mkdn"
}
