# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple podcast aggregator optimized for running as a scheduled job"
HOMEPAGE="https://podget.sourceforge.net/ https://github.com/dvehrs/podget"
SRC_URI="https://github.com/dvehrs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	app-shells/bash
	net-misc/wget
	virtual/libiconv"

src_compile() {
	# There is a Makefile that we don't want to use.
	:;
}

src_install() {
	dobin podget
	doman DOC/podget.7
	dodoc README Changelog
}
