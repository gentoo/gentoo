# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2-utils qmake-utils

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="https://github.com/fwbuilder/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	# bug 398743
	sed -i -e '/dnl.*AM_INIT_AUTOMAKE/d' configure.in || die

	# we need to run qmake ourselves using eqmake5 in src_configure to
	# ensure we respect CC, *FLAGS, etc.
	sed -i -e "/runqmake.sh/d" configure.in || die

	# bug 426262
	mv configure.in configure.ac || die

	# don't install yet another copy of the GPL
	sed -i -e '/COPYING/d' doc/doc.pro || die

	eautoreconf
}

src_configure() {
	econf \
		--without-{ccache,distcc} # portage handles ccache/distcc itself
		--with-docdir="/usr/share/doc/${PF}"
		--with-qmake="$(qt5_get_bindir)/qmake" # use fully-qualified qmake, bug #599466

	# yes, we really do need to run both econf and eqmake5...
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "You need to install sys-apps/iproute2"
	elog "in order to run the firewall script."
}

pkg_postrm() {
	gnome2_icon_cache_update
}
