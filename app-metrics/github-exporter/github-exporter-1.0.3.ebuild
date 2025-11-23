# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
DESCRIPTION="Github statistics exporter for prometheus"
HOMEPAGE="https://github.com/infinityworks/github-exporter"
SRC_URI="https://github.com/infinityworks/github-exporter/archive/${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="acct-group/github-exporter
	acct-user/github-exporter"

	src_prepare() {
		default
		sed -i -e 's/-race//' Makefile || die 'sed failed'
	}

src_compile() {
	ego build
}

src_install() {
	dobin ${PN}
	dodoc *.md
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Before you can use ${PN}, you must configure it in"
		elog "${EROOT}/etc/conf.d/${PN}"
	fi
}
