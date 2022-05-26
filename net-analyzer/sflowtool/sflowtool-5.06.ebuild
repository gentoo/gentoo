# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="sflowtool is a utility for collecting and processing sFlow data"
HOMEPAGE="
	https://inmon.com/technology/sflowTools.php
	https://github.com/sflow/sflowtool
"
SRC_URI="https://github.com/sflow/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="inmon-sflow"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

src_prepare() {
	default
	eautoreconf
}
src_configure() {
	append-cppflags -DSPOOFSOURCE
	use debug && append-cppflags -DDEBUG

	default
}

src_install() {
	default
	dobin scripts/sflowenable
}
