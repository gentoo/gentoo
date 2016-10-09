# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils

MY_PN="vertex-icons"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/horst3180/${MY_PN}"
	SRC_URI=""
	KEYWORDS=""
else
	EGIT_COMMIT="f27e47edf392596b7967b7d134d3c62ac3fda0c9"
	SRC_URI="https://github.com/horst3180/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
	S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Vertex icon theme"
HOMEPAGE="https://github.com/horst3180/vertex-icons"

LICENSE="|| ( GPL-3 GPL-2 LGPL-3 CC-BY-SA-3.0 )"
SLOT="0"
IUSE=""

RDEPEND="
	>=x11-themes/hicolor-icon-theme-0.10
"
DEPEND=""

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() { :; }

src_compile() { :; }

src_install() {
	default
	rm COPYING README.md || die

	insinto /usr/share/icons/Vertex
	doins -r *
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
