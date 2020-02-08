# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base

DESCRIPTION="OpenSMTPD filter for putting emails through rspamd"
HOMEPAGE="https://github.com/poolpOrg/filter-rspamd"
SRC_URI="https://github.com/poolpOrg/filter-rspamd/releases/download/0.1.5/filter-rspamd-0.1.5.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} mail-mta/opensmtpd"
BDEPEND=""

S=${WORKDIR}/${P#opensmtpd-}
DOCS=( README.md )

src_compile() {
	go build -ldflags="-s -w" -buildmode=pie filter-rspamd.go || die
}

src_install() {
	default
	exeinto /usr/libexec/opensmtpd
	doexe filter-rspamd
}
