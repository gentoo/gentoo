# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_DEPEND="2:2.5"
inherit eutils python scons-utils

DESCRIPTION="The SunPinYin IMEngine for IBus Framework"
HOMEPAGE="https://sunpinyin.googlecode.com"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus
		~app-i18n/sunpinyin-${PV}"
DEPEND="${RDEPEND}
		sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}/${P}-force-switch.patch"
}

src_compile() {
	escons --prefix="/usr"
}

src_install() {
	escons --prefix="/usr" --install-sandbox="${D}" install
}
