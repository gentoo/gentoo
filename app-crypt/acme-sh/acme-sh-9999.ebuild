# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/Neilpang/${PN/-/.}.git"

inherit git-r3

DESCRIPTION="An ACME Shell script"
HOMEPAGE="https://github.com/Neilpang/acme.sh"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="net-misc/curl
	|| ( dev-libs/libressl dev-libs/openssl:0 )
	|| ( net-analyzer/netcat6 net-analyzer/openbsd-netcat )
	|| ( net-misc/socat www-servers/apache:2 www-servers/nginx:0 )
	virtual/cron"

src_install() {
	einstalldocs
	newdoc dnsapi/README.md README-dnsapi.md
	newdoc deploy/README.md README-deploy.md

	keepdir /etc/acme-sh
	doenvd "${FILESDIR}"/99acme-sh
	insinto /etc/bash/bashrc.d
	doins "${FILESDIR}"/acme.sh

	exeinto /usr/share/acme.sh
	doexe acme.sh
	insinto /usr/share/acme.sh/dnsapi
	doins -r dnsapi/*.sh
	insinto /usr/share/acme.sh/deploy
	doins -r deploy/*.sh

	dosym ../share/acme.sh/acme.sh usr/bin/acme.sh
}
