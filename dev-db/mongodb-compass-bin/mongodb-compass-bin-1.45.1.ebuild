# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="GUI for MongoDB"
HOMEPAGE="https://mongodb.com/compass https://github.com/mongodb-js/compass"
SRC_URI="https://github.com/mongodb-js/compass/releases/download/v${PV}/mongodb-compass_${PV}_amd64.deb"
S=${WORKDIR}

LICENSE="SSPL-1"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="
	usr/lib/mongodb-compass/.*
"

src_install() {
	insinto /usr/lib/mongodb-compass
	doins -r usr/lib/mongodb-compass/.

	fperms +x "/usr/lib/mongodb-compass/MongoDB Compass"
	fperms 4755 /usr/lib/mongodb-compass/{chrome_crashpad_handler,chrome-sandbox}

	domenu usr/share/applications/mongodb-compass.desktop
	doicon usr/share/pixmaps/mongodb-compass.png

	make_wrapper mongodb-compass "'/usr/lib/mongodb-compass/MongoDB Compass'"
}
