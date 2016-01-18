# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

MY_PV="25a255f32eee"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="Facebook protocol plugin for libpurple"
HOMEPAGE="https://github.com/jgeboski/purple-facebook"
SRC_URI="https://github.com/jgeboski/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/json-glib
	 net-im/pidgin"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README VERSION )

src_configure() {
	econf --with-ssl-certs
}

src_prepare() {
	eautoreconf
}
