# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends."
HOMEPAGE="https://bitbucket.org/tsg-/liberasurecode/overview"
SRC_URI="https://bitbucket.org/tsg-/${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"
CUSTOM_VERSION="a380246762c1"
S="${WORKDIR}/tsg--${PN}-${CUSTOM_VERSION}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/autoconf"

src_prepare() {
	autoreconf -i -v || die "autoconf failed"
}

src_configure() {
	econf
}

src_install() {
	emake DESTDIR="${D}" install
}
