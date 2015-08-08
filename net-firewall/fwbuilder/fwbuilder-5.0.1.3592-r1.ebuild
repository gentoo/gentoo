# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils base qt4-r2 multilib autotools

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND=">=dev-qt/qtgui-4.3:4
	dev-libs/openssl
	dev-libs/elfutils"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.0.3568-ldflags.patch"
	"${FILESDIR}/${PN}-5.0.1.3592-gcc47.patch"
)

src_prepare() {
	# Fix a compile bug that affects some x86_64 platforms.
	# Addressed in the upcoming 5.0.2.3596 release.
	# Closes #395151.
	epatch "${FILESDIR}/${P}-stdc-format-macros.patch"

	qt4-r2_src_prepare
	sed -i -e '/dnl.*AM_INIT_AUTOMAKE/d' configure.in || die #398743
	eautoreconf
}

src_configure() {
	eqmake4
	# portage handles ccache/distcc itself
	econf --without-{ccache,distcc}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	validate_desktop_entries

	elog "You need to emerge sys-apps/iproute2 on the machine"
	elog "that will run the firewall script."
}
