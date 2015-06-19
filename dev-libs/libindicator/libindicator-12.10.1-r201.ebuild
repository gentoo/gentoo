# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicator/libindicator-12.10.1-r201.ebuild,v 1.1 2015/05/07 18:32:21 mgorny Exp $

EAPI=5
inherit eutils flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://launchpad.net/libindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( dev-util/dbus-test-runner )"

multilib_src_configure() {
	append-flags -Wno-error

	myconf=(
		--disable-silent-rules
		--disable-static
		--with-gtk=2
	)
	local ECONF_SOURCE=${S}
	econf "${myconf[@]}"
}

multilib_src_test() {
	Xemake check #391179
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	rm -vf \
		"${ED}"/usr/lib*/libdummy-indicator-* \
		"${ED}"/usr/share/${PN}/*indicator-debugging
}
