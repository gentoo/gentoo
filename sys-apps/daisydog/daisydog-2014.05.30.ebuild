# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs flag-o-matic

GIT_SHA1="3182aa85c087446e4358370549adc45db21ec124"
MY_P="${PN}-${GIT_SHA1}"

DESCRIPTION="A very simple /dev/watchdog daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/daisydog/+/master"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz
	https://chromium.googlesource.com/chromiumos/third_party/daisydog/+archive/${GIT_SHA1}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="static"

S=${WORKDIR}

src_configure() {
	tc-export CC
	use static && append-ldflags -static
}

src_install() {
	dobin daisydog
	dodoc README.chromiumos

	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
}
