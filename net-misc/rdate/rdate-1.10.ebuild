# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=openrdate

DESCRIPTION="Use TCP or UDP to retrieve the current time of another machine"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/openrdate"
SRC_URI="https://github.com/resurrecting-open-source-projects/${MY_P}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-libs/libbsd"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}-${PV}

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newinitd "${FILESDIR}"/rdate-initd-1.4-r3 rdate
	newconfd "${FILESDIR}"/rdate-confd rdate
}
