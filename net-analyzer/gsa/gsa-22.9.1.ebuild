# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_N="node-modules"
MY_NODE_D="node_modules"
MY_NODE_PV="${PV}"

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gsa"
SRC_URI="
	https://github.com/greenbone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/greenbone/${PN}/releases/download/v${PV}/${PN}-${MY_NODE_N}-${PV}.tar.xz
"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=net-libs/nodejs-18.0.0[ssl]
	>=sys-apps/yarn-1.22
"

MY_NODE_DIR="${S}/${MY_NODE_D}/"

src_prepare() {
	default
	# We will use pre-generated npm stuff.
	mv "${WORKDIR}/${MY_NODE_D}" "${MY_NODE_DIR}" || die "couldn't move node_modules"

	# Make SVGR not traverse the path up to / looking for a
	# configuration file. Fixes
	# Error: EACCES: permission denied, open '/.config/svgrrc'
	# in case a directory /.config exists, see https://bugs.gentoo.org/909731
	echo "runtimeConfig: false" > .svgrrc.yml || die
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
