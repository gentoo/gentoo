# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs-mod systemd

DESCRIPTION="Process manager for Node.js applications with a built-in load balancer"
HOMEPAGE="https://pm2.keymetrics.io/"
SRC_URI="https://github.com/Unitech/pm2/archive/${PV}.tar.gz -> ${P}.tar.gz
			https://raw.githubusercontent.com/inode64/inode64-overlay/main/dist/${P}-node_modules.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

NODEJS_EXTRA_FILES="bin constants.js index.js paths.js"

src_install() {
	nodejs-mod_src_install

	dosym ../lib64/node_modules/pm2/bin/pm2 /usr/bin/pm2
	dosym ../lib64/node_modules/pm2/bin/pm2-dev /usr/bin/pm2-dev
	dosym ../lib64/node_modules/pm2/bin/pm2-docker /usr/bin/pm2-docker
	dosym ../lib64/node_modules/pm2/bin/pm2-runtime /usr/bin/pm2-runtime

	doinitd "${FILESDIR}"/${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
}
