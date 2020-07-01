# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

MY_P="${P/_rc/-rc}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="Linux Trace Toolkit - next generation"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~amd64 ~x86"
IUSE="+ust"

DEPEND="dev-libs/userspace-rcu:=
	dev-libs/popt
	dev-libs/libxml2
	ust? ( dev-util/lttng-ust:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if kernel_is -lt 2 6 27; then
		ewarn "${PN} require Linux kernel >= 2.6.27"
		ewarn "   pipe2(), epoll_create1() and SOCK_CLOEXEC are needed to run"
		ewarn "   the session daemon. There were introduce in the 2.6.27"
	fi
}

src_configure() {
	econf $(usex ust "" --without-lttng-ust)
}
