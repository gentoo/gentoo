# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="User-mode networking for unprivileged network namespaces"
HOMEPAGE="https://github.com/rootless-containers/slirp4netns"
SRC_URI="https://github.com/rootless-containers/slirp4netns/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/glib:2=
	dev-libs/libpcre:=
	sys-libs/libseccomp:=
	sys-libs/libcap:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"
RESTRICT="test"

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
