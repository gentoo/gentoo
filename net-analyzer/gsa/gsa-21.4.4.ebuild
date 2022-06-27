# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_N="node_modules"
MY_NODE_PV="21.4.2"

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gsa"
SRC_URI="
	https://github.com/greenbone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/greenbone/${PN}/releases/download/v${MY_NODE_PV}/gsa-node-modules-${MY_NODE_PV}.tar.gz -> ${PN}-${MY_NODE_PV}-${MY_NODE_N}.tar.gz
"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=net-libs/nodejs-14.0.0[ssl]
	>=sys-apps/yarn-1.15.2
"

MY_NODE_DIR="${S}/${MY_NODE_N}/"

src_prepare() {
	default
	# We will use pre-generated npm stuff.
	mv "${WORKDIR}/${MY_NODE_N}" "${MY_NODE_DIR}" || die "couldn't move node_modules"
}

src_compile() {
	# setting correct PATH for finding react-js
	NODE_ENV=production PATH="${PATH}:${MY_NODE_DIR}/.bin/" \
			yarn --offline build || die
}

src_install() {
	insinto "usr/share/gvm/gsad/web"
	doins -r build/*
}
