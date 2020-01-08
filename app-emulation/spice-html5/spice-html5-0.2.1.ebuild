# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Spice Javascript client"
HOMEPAGE="https://gitlab.freedesktop.org/spice/spice-html5"
SRC_URI="https://gitlab.freedesktop.org/spice/${PN}/-/archive/${P}/${PN}-${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

# no compiling
src_compile() {
	true
}

src_install() {
	insinto /usr/share/spice-html5
	doins -r src apache.conf.sample spice.css spice.html spice_auto.html
}
