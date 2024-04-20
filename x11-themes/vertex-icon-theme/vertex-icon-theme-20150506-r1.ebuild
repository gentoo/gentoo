# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

MY_PN="vertex-icons"
EGIT_COMMIT="f27e47edf392596b7967b7d134d3c62ac3fda0c9"

DESCRIPTION="Vertex icon theme"
HOMEPAGE="https://github.com/horst3180/vertex-icons"
SRC_URI="https://github.com/horst3180/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

LICENSE="|| ( GPL-3 GPL-2 LGPL-3 CC-BY-SA-3.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"

src_configure() { :; }

src_compile() { :; }

src_install() {
	default
	rm COPYING README.md || die

	insinto /usr/share/icons/Vertex
	doins -r .
}
