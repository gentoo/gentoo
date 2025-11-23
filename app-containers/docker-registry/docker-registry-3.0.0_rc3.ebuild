# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV=${PV/_rc/-rc.}
EGIT_COMMIT="51bdcb7bac069f263ce238db6bd0610759c2635f"

DESCRIPTION="Docker Registry 2.0"
HOMEPAGE="https://github.com/docker/distribution"
SRC_URI="https://github.com/docker/distribution/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/distribution-${MY_PV}

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	acct-group/registry
	acct-user/registry
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "s/-s -w/-w/" -i Makefile || die

	# bug 949973
	sed -e "s/TestHTTPChecker/_&/" -i health/checks/checks_test.go || die
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
