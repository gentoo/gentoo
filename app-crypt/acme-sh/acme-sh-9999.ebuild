# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 optfeature

DESCRIPTION="A pure Unix shell script implementing ACME client protocol"
HOMEPAGE="https://github.com/acmesh-official/acme.sh"
EGIT_REPO_URI="https://github.com/acmesh-official/${PN/-/.}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="selinux"

RDEPEND="
	dev-libs/openssl:0
	net-misc/curl
	net-misc/socat
	selinux? ( sec-policy/selinux-certbot )
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
	optfeature_header "For webserver mode, install a supported web server:"
	optfeature "using apache2 webserver mode" www-servers/apache
	optfeature "using nginx webserver mode" www-servers/nginx
}
