# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-gpg/pidgin-gpg-0.9.3.ebuild,v 1.1 2015/05/29 19:04:34 mrueg Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Pidgin GPG/OpenPGP (XEP-0027) plugin"
HOMEPAGE="https://github.com/Draghtnod/Pidgin-GPG"
SRC_URI="https://github.com/Draghtnod/Pidgin-GPG/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-crypt/gpgme
	net-im/pidgin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/Pidgin-GPG-${PV}"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --all
}
