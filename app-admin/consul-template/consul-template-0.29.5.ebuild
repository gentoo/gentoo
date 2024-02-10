# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="Generic template rendering and notifications with Consul"
HOMEPAGE="https://github.com/hashicorp/consul-template"
SRC_URI="https://github.com/hashicorp/consul-template/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/consul-template-0.29.4-deps.tar.xz"

LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 ISC MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
	acct-group/consul-template
	acct-user/consul-template"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

# TODO: debug test failures
RESTRICT+=" test"

src_prepare() {
	default
	# remove -s and -w from the linker flags
	sed \
		-e '/-s \\/d' \
		-e '/-w \\/d' \
		-i Makefile || die
}

src_compile() {
	emake GOBIN="${S}"/bin dev
}

src_test() {
	emake GOBIN="${S}"/bin test
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGELOG.md README.md

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
