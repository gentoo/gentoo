# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/purple-facebook/purple-facebook-20150713.ebuild,v 1.2 2015/07/15 18:40:53 chainsaw Exp $

EAPI=5

inherit eutils autotools

MY_PV="4098e875ebcb"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="Facebook protocol plugin for libpurple"
HOMEPAGE="https://github.com/jgeboski/purple-facebook"
SRC_URI="https://github.com/jgeboski/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-im/pidgin[-gnutls]"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README VERSION )

src_prepare() {
	eautoreconf
}
