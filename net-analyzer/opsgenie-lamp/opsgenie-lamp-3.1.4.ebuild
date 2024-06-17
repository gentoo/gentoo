# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="command line client for the opsgenie service"
HOMEPAGE="https://docs.opsgenie.com/docs/lamp-command-line-interface-for-opsgenie"
SRC_URI="https://github.com/opsgenie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# yes, CHANEGLOG.md is a typo in the source
DOCS=( CHANEGLOG.md README.md )

src_compile() {
	ego build -mod=vendor
}

src_install() {
	newbin ${PN} lamp
	dodoc conf/lamp.conf
	einstalldocs
}
