# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A UI for Focusrite Scarlett and Clarett audio interfaces"
HOMEPAGE="https://github.com/geoffreybennett/alsa-scarlett-gui"
MY_PV="32c00623676e70572195ef28fd01ab8409b82541"
SRC_URI="https://github.com/geoffreybennett/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}/src"

export PREFIX="/usr"
