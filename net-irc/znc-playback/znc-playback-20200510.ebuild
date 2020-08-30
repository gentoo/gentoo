# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="8dd128bfe2b24b2cc6a9ea2e2d28bfaa28d2a833"

DESCRIPTION="A ZNC module to control buffer playback"
HOMEPAGE="https://github.com/jpnurmi/znc-playback"
SRC_URI="https://github.com/jpnurmi/znc-playback/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-irc/znc:="

RDEPEND="${DEPEND}"

DOCS=( README.md )

S="${WORKDIR}/${PN}-${MY_COMMIT}"

src_prepare() {
	default

	# No parallel build support
	MAKEOPTS=-j1
}

src_install() {
	insinto /usr/$(get_libdir)/znc
	doins playback.so

	einstalldocs
}
