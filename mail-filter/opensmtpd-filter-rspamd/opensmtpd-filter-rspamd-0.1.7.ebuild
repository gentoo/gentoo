# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"golang.org/x/sys v0.0.0-20200821140526-fda516888d29"
	"golang.org/x/sys v0.0.0-20200821140526-fda516888d29/go.mod"
)
go-module_set_globals

MY_PN="${PN#opensmtpd-}"
DESCRIPTION="OpenSMTPD filter for putting emails through rspamd"
HOMEPAGE="https://github.com/poolpOrg/filter-rspamd"
SRC_URI="https://github.com/poolpOrg/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="mail-mta/opensmtpd"

DOCS=( README.md )

src_compile() {
	ego build -ldflags="-s -w" -buildmode=pie -o filter-rspamd
}

src_install() {
	exeinto /usr/libexec/opensmtpd
	doexe filter-rspamd

	doman filter-rspamd.8
	einstalldocs
}
