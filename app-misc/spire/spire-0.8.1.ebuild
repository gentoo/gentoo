# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VENDOR_URI="https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.gz"

DESCRIPTION="the spiffe runtime environment"
HOMEPAGE="https://github.com/spiffe/spire"
SRC_URI="https://github.com/spiffe/spire/archive/${PV}.tar.gz -> ${P}.tar.gz
	${VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="acct-group/spire
	acct-user/spire"
DEPEND="${COMMON_DEPEND}
	dev-lang/go"
RDEPEND="${COMMON_DEPEND}"

RESTRICT="strip"

src_prepare() {
	default
	mv ../vendor . || die "Unable to move ../vendor directory"
}

do_cmd() {
	if [[ -z "$@" ]]; then
		die "No arguments passed to do_cmd"
	fi
	echo $@
	$@ || die
}

src_compile() {
do_cmd cd cmd/spire-agent
	do_cmd go build -mod vendor -o ../../spire-agent
do_cmd cd ../../cmd/spire-server
	do_cmd go build -mod vendor -o ../../spire-server
}

src_install() {
	exeinto /opt/spire
	doexe spire-agent spire-server
	keepdir /opt/spire/.data
	fowners spire:spire /opt/spire/.data
	insinto /etc/spire
	doins -r conf/*
	dosym ../../etc/spire /opt/spire/conf
	dosym ../../opt/spire/spire-agent /usr/bin/spire-agent
	dosym ../../opt/spire/spire-server /usr/bin/spire-server
	newconfd "${FILESDIR}"/spire-agent.confd spire-agent
	newinitd "${FILESDIR}"/spire-agent.initd spire-agent
	newconfd "${FILESDIR}"/spire-server.confd spire-server
	newinitd "${FILESDIR}"/spire-server.initd spire-server
keepdir /var/log/spire
fowners spire:spire /var/log/spire
}
