# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Minimal, Configurable, Single-User GTK3 LightDM Greeter"
HOMEPAGE="https://github.com/prikhi/lightdm-mini-greeter"
SRC_URI="https://github.com/prikhi/lightdm-mini-greeter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	>=x11-libs/gtk+-3.14:3
	>=x11-misc/lightdm-1.12
"
DEPEND="${RDEPEND}"

DOCS="CHANGELOG.md README.md"

src_prepare() {
	sed -i -e 's/-Werror//' Makefile.am || die

	eapply_user
	eautoreconf
}
