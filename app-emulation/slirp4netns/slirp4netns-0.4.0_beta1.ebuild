# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV=${PV/_/-}
MY_PV=${MY_PV/beta/beta.}
MY_P=${PN}-${MY_PV}
DESCRIPTION="User-mode networking for unprivileged network namespaces"
HOMEPAGE="https://github.com/rootless-containers/slirp4netns"
SRC_URI="https://github.com/rootless-containers/slirp4netns/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND="dev-libs/glib:2=
	dev-libs/libpcre:="
DEPEND="${RDEPEND}"
RESTRICT="test"
S=${WORKDIR}/${MY_P}

src_prepare() {
	eautoreconf
	default
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You need to have the tun kernel module loaded in order to have"
		elog "slirp4netns working"
	fi
}
