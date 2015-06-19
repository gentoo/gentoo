# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-tutcode/ibus-tutcode-1.0.2-r1.ebuild,v 1.1 2014/12/27 11:31:15 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="a Japanese TUT-Code input engine for IBus"
HOMEPAGE="https://github.com/deton/ibus-tutcode/"
SRC_URI="mirror://github/deton/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

CDEPEND="${PYTHON_DEPS}
	>=sys-devel/gettext-0.16.1"
DEPEND="${CDEPEND}
	test? ( app-i18n/ibus )"
RDEPEND="${CDEPEND}
	app-i18n/ibus"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	sed -i -e "s/python/${EPYTHON}/" engine/ibus-engine-tutcode.in || die
}

src_install() {
	default
	dodoc ${PN}.json.example
}
