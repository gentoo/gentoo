# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_COMMIT="5946cab2fab41c40b237a69e3aca08b1180cbc10"
DESCRIPTION="a Latin date(1)"
HOMEPAGE="http://hodie.sourceforge.net
		https://github.com/michiexile/hodie"
SRC_URI="https://github.com/michiexile/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${MY_COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	doman hodie.1
}
