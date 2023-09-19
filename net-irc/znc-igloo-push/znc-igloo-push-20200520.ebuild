# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="f952b87a1fc235917a28fbabbe8626719d622e4c"

DESCRIPTION="A ZNC module which provides push notifications for Igloo client"
HOMEPAGE="https://git.jordanko.ch/Igloo/Push"
SRC_URI="https://git.jordanko.ch/Igloo/Push/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-irc/znc:=[ssl]"

RDEPEND="${DEPEND}"

DOCS=( README.md )

S="${WORKDIR}/push"

src_prepare() {
	default

	# No parallel build support
	MAKEOPTS=-j1
}

src_install() {
	insinto /usr/$(get_libdir)/znc
	doins push.so

	einstalldocs
}
