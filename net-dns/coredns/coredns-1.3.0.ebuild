# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/mholt/caddy 6f580c6aa36c54c3e1c65b5c609550a8a2508e3e"
	"github.com/miekg/dns 7586a3cbe8ccfc63f82de3ab2ceeb08c9939af72"
	"github.com/prometheus/client_golang 505eaef017263e299324067d40ca2c48f6a2cf50"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/prometheus/procfs 1dc9a6cbc91aacc3e8b2d63db4d2e957a5394ac4"
)

EGO_PN="github.com/${PN}/${PN}"

inherit golang-build golang-vcs-snapshot

GITCOMMIT="c8f0e94026b5f3530064dd3266eef1a80e3b0f1c"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${GITCOMMIT}" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}
	dobin ${PN}
	dodoc README.md
	doman man/*
	popd || die

	newinitd "${FILESDIR}"/coredns.initd coredns
	newconfd "${FILESDIR}"/coredns.confd coredns

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/coredns.logrotated coredns
}
