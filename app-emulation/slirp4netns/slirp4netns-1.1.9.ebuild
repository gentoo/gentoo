# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="User-mode networking for unprivileged network namespaces"
HOMEPAGE="https://github.com/rootless-containers/slirp4netns"
SRC_URI="https://github.com/rootless-containers/slirp4netns/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm64"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/glib:2=
	dev-libs/libpcre:=
	net-libs/libslirp:=
	sys-libs/libseccomp:=
	sys-libs/libcap:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"
RESTRICT="test"

src_prepare() {
	# Respect AR variable for bug 722162.
	sed -e 's|^AC_PROG_CC$|AC_DEFUN([AC_PROG_AR], [AC_CHECK_TOOL(AR, ar, :)])\nAC_PROG_AR\n\0|' \
		-i configure.ac || die
	eautoreconf
	default
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You need to have the tun kernel module loaded in order to have"
		elog "slirp4netns working"
	fi
}
