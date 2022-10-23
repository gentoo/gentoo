# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="crosstool-ng is a tool to build cross-compiling toolchains"
HOMEPAGE="https://crosstool-ng.github.io/"
MY_P=${P/ct/crosstool}
SRC_URI="http://ymorin.is-a-geek.org/download/crosstool-ng/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="net-misc/curl
	dev-util/gperf
	dev-vcs/cvs
	dev-vcs/subversion"

S="${WORKDIR}/crosstool-ng-${PV}"

src_install() {
	emake DESTDIR="${D}" install
	use doc && mv "${D}"/usr/share/doc/crosstool-ng/crosstool-ng-${PVR} \
		"${D}"/usr/share/doc/
	rm -rf "${D}"/usr/share/doc/crosstool-ng
}
