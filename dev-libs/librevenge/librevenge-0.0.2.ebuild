# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/librevenge/librevenge-0.0.2.ebuild,v 1.4 2015/04/30 05:55:28 jer Exp $

EAPI="5"

inherit eutils multilib-minimal

DESCRIPTION="A helper library for REVerse ENGineered formats filters"
HOMEPAGE="http://sf.net/p/libwpd/librevenge"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/libwpd/librevenge"
	inherit git-r3 autotools
	KEYWORDS="~ppc64"
else
	SRC_URI="http://sf.net/projects/libwpd/files/${PN}/${P}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc64 x86 ~x86-fbsd"
fi

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0"
IUSE="doc test"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit[${MULTILIB_USEDEP}] )
"

src_prepare() {
	[[ ${PV} = 9999 ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable test tests) \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

multilib_src_install_all() {
	prune_libtool_files --all
}
