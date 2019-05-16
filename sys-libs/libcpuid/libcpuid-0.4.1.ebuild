# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A small C library for x86 (and x86_64) CPU detection and feature extraction"
HOMEPAGE="http://libcpuid.sourceforge.net https://github.com/anrieff/libcpuid"
SRC_URI="https://github.com/anrieff/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0/14"
KEYWORDS="-* ~amd64 ~x86"
IUSE="test"

src_prepare() {
	default
	eautoreconf
}

src_test() {
	emake test
}
