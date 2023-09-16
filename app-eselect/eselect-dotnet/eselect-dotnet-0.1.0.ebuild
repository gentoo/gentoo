# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Eselect module for management of multiple dotnet versions"
HOMEPAGE="https://gitlab.gentoo.org/dotnet/eselect-dotnet/"
SRC_URI="https://gitlab.gentoo.org/dotnet/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="app-admin/eselect"

src_install() {
	insinto /usr/share/eselect/modules
	doins dotnet.eselect
}
