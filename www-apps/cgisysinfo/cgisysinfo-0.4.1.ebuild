# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools

if [[ ${PV} = *9999* ]]; then
	WANT_AUTOMAKE="1.10"
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}"
	KEYWORDS=""
	DOCS=( "README.md" "AUTHORS" "NEWS" )
else
	SRC_URI="https://github.com/rafaelmartins/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	DOCS=( "README" "AUTHORS" "NEWS" )
fi

DESCRIPTION="A small cgi utility to show basic system information"
HOMEPAGE="https://github.com/rafaelmartins/cgisysinfo"

LICENSE="GPL-2"
SLOT="0"
IUSE="fastcgi"

DEPEND="fastcgi? ( dev-libs/fcgi )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable fastcgi)
}
