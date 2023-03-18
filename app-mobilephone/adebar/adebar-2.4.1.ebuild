# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="Android DEvice Backup And Report, using Bash and ADB"
HOMEPAGE="https://codeberg.org/izzy/Adebar"
SRC_URI="https://codeberg.org/izzy/Adebar/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-shells/bash
	dev-util/android-tools
"

S="${WORKDIR}/${PN}"

DISABLE_AUTOFORMATTING="no"
DOC_CONTENTS="Please refer to the documentation at https://codeberg.org/izzy/Adebar/wiki.
You can find example configurations at ${ROOT}/usr/share/doc/${PF}.
To customize, copy to \${XDG_CONFIG_HOME}/${PN} and edit it to your liking.
Contrary to the documentation, the Gentoo installation does not allow
configuration files relative to main program ${PN} installed to /usr/bin.
So the documentation must be placed in the users home directory."

src_prepare() {
	default

	sed -i -e 's|\(BINDIR=\).*|\1"/usr/share/adebar"|' ${PN}-cli
	sed -i -e 's|\(LIBDIR=\).*|\1"/usr/lib/adebar"|' ${PN}-cli
	sed -i -e '/-d "\$HOME\/\.config\/adebar"/,+2d' ${PN}-cli
}

src_install() {
	local libdir=/usr/lib/${PN}
	local sharedir=/usr/share/${PN}

	newbin ${PN}-cli ${PN}

	insinto ${libdir}
	doins -r lib/*

	exeinto ${sharedir}/tools
	doexe tools/*
	fperms 0644 ${sharedir}/tools/xml2array.php

	insinto ${sharedir}/templates
	doins -r templates/*

	dodoc -r doc/*
	dodoc README.md

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
