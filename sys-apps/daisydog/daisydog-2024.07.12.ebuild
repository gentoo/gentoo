# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

GIT_SHA1="c24ad8bc3682292d289537dfaa19bf549abfcc15"
MY_P="${PN}-${GIT_SHA1}"

DESCRIPTION="A very simple /dev/watchdog daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/daisydog/+/master"
SRC_URI="
	https://chromium.googlesource.com/chromiumos/third_party/daisydog/+archive/${GIT_SHA1}.tar.gz
		-> ${MY_P}.tar.gz
"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 sparc ~x86"
IUSE="static"

src_configure() {
	tc-export CC
	use static && append-ldflags -static
}

src_install() {
	einstalldocs

	dobin daisydog

	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}.init.d-r1 ${PN}
}
