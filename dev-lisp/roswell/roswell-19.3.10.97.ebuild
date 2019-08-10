# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A lisp installer and launcher for major environment"
HOMEPAGE="https://github.com/roswell/roswell"
SRC_URI="https://github.com/roswell/roswell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"

RDEPEND="!net-libs/librouteros"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake -j1
}

src_test() {
	emake -j1 check
}

src_install() {
	emake DESTDIR="${D}" -j1 install
}
