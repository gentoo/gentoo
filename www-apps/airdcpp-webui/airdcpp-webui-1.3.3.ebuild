# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Web interface for airdcpp-webclient"
HOMEPAGE="https://airdcpp-web.github.io/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="=net-p2p/airdcpp-webclient-${PV%.*}*"

S="${WORKDIR}/package"

src_install() {
	insinto "/usr/share/airdcpp/web-resources"
	doins -r "${S}/dist"/*
}
