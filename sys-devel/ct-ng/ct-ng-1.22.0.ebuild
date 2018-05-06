# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit bash-completion-r1

DESCRIPTION="crosstool-ng is a tool to build cross-compiling toolchains"
HOMEPAGE="https://crosstool-ng.org"
MY_P=${P/ct/crosstool}
SRC_URI="http://ymorin.is-a-geek.org/download/crosstool-ng/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="net-misc/curl
	<dev-util/gperf-3.1
	dev-vcs/cvs
	dev-vcs/subversion"

S="${WORKDIR}/crosstool-ng"

src_install() {
	emake DESTDIR="${D%/}" install
	newbashcomp ${PN}.comp ${PN}
	use doc && mv "${D}"/usr/share/doc/crosstool-ng/crosstool-ng-${PVR} \
		"${D}"/usr/share/doc/
	rm -rf "${D}"/usr/share/doc/crosstool-ng
}
