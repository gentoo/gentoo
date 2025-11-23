# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="OpenSMTPD filter for putting emails through rspamd"
HOMEPAGE="https://github.com/poolpOrg/filter-rspamd"
SRC_URI="https://github.com/poolpOrg/filter-rspamd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/mail-filter/${PN}/${P}-deps.tar.xz"
S=${WORKDIR}/${P#opensmtpd-}

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="mail-mta/opensmtpd"

DOCS=( README.md )

src_compile() {
	ego build -ldflags="-s -w" -buildmode=pie -o filter-rspamd
}

src_install() {
	default
	exeinto /usr/libexec/opensmtpd
	doexe filter-rspamd
}
