# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2-utils qmake-utils eapi7-ver

DESCRIPTION="A firewall GUI"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"
if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="https://github.com/fwbuilder/fwbuilder"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV=$(ver_rs 3 '-')
	S="${WORKDIR}/${PN}-$(ver_rs 3 '-')"
	SRC_URI="https://github.com/fwbuilder/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	net-analyzer/net-snmp
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

# https://github.com/fwbuilder/fwbuilder/pull/63
PATCHES=( "${FILESDIR}/${P}-gcc-maybe-uninitialized.patch" )

src_prepare() {
	default

	# bug 426262
	mv configure.in configure.ac || die

	# don't install yet another copy of the GPL
	sed -i -e '/COPYING/d' doc/doc.pro || die

	eautoreconf
}

src_configure() {
	econf \
		--without-{ccache,distcc} \
		--with-docdir="/usr/share/doc/${PF}"

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
