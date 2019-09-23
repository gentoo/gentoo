# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

SRC_URI="https://github.com/rafaelmartins/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A small cgi utility to show basic system information"
HOMEPAGE="https://github.com/rafaelmartins/cgisysinfo"

LICENSE="GPL-2"
SLOT="0"
IUSE="fastcgi"

KEYWORDS="~amd64 ~x86"
DOCS=( "README" "AUTHORS" "NEWS" )

DEPEND="fastcgi? ( dev-libs/fcgi )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable fastcgi)
}
