# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/rigo/rigo-254.ebuild,v 1.1 2013/12/18 05:07:53 lxnay Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils fdo-mime python-single-r1

DESCRIPTION="Rigo, the Sabayon Application Browser"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/rigo"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	|| ( dev-python/pygobject-cairo:3 dev-python/pygobject:3[cairo] )
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	~sys-apps/rigo-daemon-${PV}[${PYTHON_USEDEP}]
	sys-devel/gettext
	x11-libs/gtk+:3
	x11-libs/vte:2.90
	>=x11-misc/xdg-utils-1.1.0_rc1_p20120319"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	python_optimize "${D}/usr/lib/rigo/${PN}"
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
