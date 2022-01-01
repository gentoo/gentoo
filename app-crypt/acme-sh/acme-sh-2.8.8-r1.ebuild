# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

inherit optfeature

DESCRIPTION="A pure Unix shell script implementing ACME client protocol"
HOMEPAGE="https://github.com/acmesh-official/acme.sh"
SRC_URI="https://github.com/acmesh-official/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-libs/openssl:0
	net-misc/curl
	net-misc/socat
"

src_install() {
	newdoc deploy/README.md README-deploy.md
	newdoc dnsapi/README.md README-dnsapi.md
	rm {deploy,dnsapi}/README.md || die
	einstalldocs

	exeinto /usr/share/acme.sh
	doexe acme.sh

	insinto /usr/share/acme.sh
	doins -r deploy dnsapi notify

	keepdir /etc/acme-sh
	doenvd "${FILESDIR}"/99acme-sh

	insinto /etc/bash/bashrc.d
	doins "${FILESDIR}"/acme.sh

	dosym ../share/acme.sh/acme.sh usr/bin/acme.sh
}

pkg_postinst() {
	einfo "If you wish to use the webserver mode,"
	einfo "you need to install a supported web server."
	optfeature "using apache2 webserver mode." www-servers/apache
	optfeature "using nginx webserver mode." www-servers/nginx
}
