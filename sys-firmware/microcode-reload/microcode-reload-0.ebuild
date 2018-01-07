# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit tmpfiles

DESCRIPTION="Installs tmpfiles.d to reload CPU microcode"
HOMEPAGE="https://gentoo.org/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

src_install() {
	dotmpfiles "${FILESDIR}/microcode-reload.conf"
}
