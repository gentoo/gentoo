# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gsa"
SRC_URI="
	https://github.com/greenbone/${PN}/releases/download/v${PV}/gsa-dist-${PV}.tar.gz -> ${P}-dist.tar.gz
"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	default
	mkdir ${P}
	mv static/ "${WORKDIR}"/${P}/
	mv locales/ "${WORKDIR}"/${P}/
	mv img/ "${WORKDIR}"/${P}/
	mv robots.txt "${WORKDIR}"/${P}/
	mv index.html "${WORKDIR}"/${P}/
}

src_install() {
	insinto "usr/share/gvm/gsad/web"
	doins -r ./*
}
