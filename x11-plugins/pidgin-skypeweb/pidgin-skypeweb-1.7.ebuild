# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SkypeWeb Plugin for Pidgin"
HOMEPAGE="https://github.com/EionRobb/skype4pidgin"
SRC_URI="https://github.com/EionRobb/skype4pidgin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

BDEPEND="virtual/pkgconfig"
RDEPEND="net-im/pidgin
	dev-libs/json-glib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/skype4pidgin-${PV}/skypeweb"

pkg_postinst() {
	elog "If you get error message like 'Failed getting Magic T value':"
	elog "Go to https://web.skype.com ; Log In and follow the instructions to enable your account!"
}
