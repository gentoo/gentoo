# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV=${PV/_rc/-rc.}
EGIT_COMMIT="4890d9e03616d563083fa944aaa083cc49b54ff5"

DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
SRC_URI="https://github.com/docker/distribution/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/distribution-${MY_PV}

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	acct-group/registry
	acct-user/registry
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "s/-s -w/-w/" -i Makefile || die
}

src_compile() {
	local -x GO_BUILD_FLAGS="-v -mod=vendor"
	emake VERSION="${MY_PV}" REVISION="${EGIT_COMMIT}" binaries
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe bin/*

	insinto /etc/docker/registry
	newins cmd/registry/config-example.yml config.yml.example

	newinitd "${FILESDIR}/registry.initd" registry
	newconfd "${FILESDIR}/registry.confd" registry
	systemd_dounit "${FILESDIR}/registry.service"

	keepdir /var/log/registry
	fowners registry:registry /var/log/registry

	insinto /etc/logrotate.d
	newins "${FILESDIR}/registry.logrotated" registry
}
