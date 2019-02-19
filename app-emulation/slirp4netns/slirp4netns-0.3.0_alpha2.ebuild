# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="User-mode networking for unprivileged network namespaces"
HOMEPAGE="https://github.com/rootless-containers/slirp4netns"
SRC_URI="https://github.com/rootless-containers/slirp4netns/archive/v${PV/_alpha/-alpha.}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
RESTRICT="test"

S="${WORKDIR}/${P/_alpha/-alpha.}"

src_prepare() {
	eautoreconf
	default
}

pkg_postinst() {
	elog "You need to have the tun kernel module loaded in order to have"
	elog "slirp4netns working"
}
