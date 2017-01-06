# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/ContainX/docker-volume-netshare/..."
EGIT_COMMIT="07ecbb79beb37b05f5a292cc45c28c1b2d251c70"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/Sirupsen/logrus/archive/3ec0642a7fb6488f65b06f9040adc67e3990296a.tar.gz -> Sirupsen-logrus-3ec0642a7fb6488f65b06f9040adc67e3990296a.tar.gz
	https://github.com/dickeyxxx/netrc/archive/3acf1b3de25d89c7688c63bb45f6b07f566555ec.tar.gz -> dickeyxxx-netrc-3acf1b3de25d89c7688c63bb45f6b07f566555ec.tar.gz
	https://github.com/docker/go-plugins-helpers/archive/8a0198e77ac4e4ee167222caf6894cb32386c5fc.tar.gz -> docker-go-plugins-helpers-8a0198e77ac4e4ee167222caf6894cb32386c5fc.tar.gz
	https://github.com/coreos/go-systemd/archive/7c9533367ef925dc1078d75e5b7141e10da2c4e8.tar.gz -> coreos-go-systemd-7c9533367ef925dc1078d75e5b7141e10da2c4e8.tar.gz
	https://github.com/coreos/pkg/archive/447b7ec906e523386d9c53be15b55a8ae86ea944.tar.gz -> coreos-pkg-447b7ec906e523386d9c53be15b55a8ae86ea944.tar.gz
	https://github.com/docker/go-connections/archive/988efe982fdecb46f01d53465878ff1f2ff411ce.tar.gz -> docker-go-connections-988efe982fdecb46f01d53465878ff1f2ff411ce.tar.gz
	https://github.com/opencontainers/runc/archive/1a9dd2678d2d6ad574f05cb7b9ae46ce65586725.tar.gz -> opencontainers-runc-1a9dd2678d2d6ad574f05cb7b9ae46ce65586725.tar.gz
	https://github.com/miekg/dns/archive/58f52c57ce9df13460ac68200cef30a008b9c468.tar.gz -> miekg-dns-58f52c57ce9df13460ac68200cef30a008b9c468.tar.gz
	https://github.com/spf13/cobra/archive/856b96dcb49d6427babe192998a35190a12c2230.tar.gz -> spf13-cobra-856b96dcb49d6427babe192998a35190a12c2230.tar.gz
	https://github.com/spf13/pflag/archive/dabebe21bf790f782ea4c7bbd2efc430de182afd.tar.gz -> spf13-pflag-dabebe21bf790f782ea4c7bbd2efc430de182afd.tar.gz
	https://github.com/golang/net/archive/905989bd20b7c354fd28a61074eed1c8f49ebc89.tar.gz -> golang-net-905989bd20b7c354fd28a61074eed1c8f49ebc89.tar.gz"
DESCRIPTION="Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin"
HOMEPAGE="https://github.com/ContainX/docker-volume-netshare"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

_golang-include-src() {
	local VENDORPN=$1 TARBALL=$2
	mkdir -p "${WORKDIR}/${P}/src/${VENDORPN}" || die
	tar -C "${WORKDIR}/${P}/src/${VENDORPN}" -x --strip-components 1\
		-f "${DISTDIR}"/${TARBALL} || die
}

src_unpack() {
	golang-vcs-snapshot_src_unpack
	_golang-include-src github.com/Sirupsen/logrus Sirupsen-logrus-*.tar.gz
	_golang-include-src github.com/dickeyxxx/netrc dickeyxxx-netrc-*.tar.gz
	_golang-include-src github.com/docker/go-plugins-helpers docker-go-plugins-helpers-*.tar.gz
	_golang-include-src github.com/coreos/go-systemd coreos-go-systemd-*.tar.gz
	_golang-include-src github.com/coreos/pkg coreos-pkg-*.tar.gz
	_golang-include-src github.com/docker/go-connections docker-go-connections-*.tar.gz
	_golang-include-src github.com/miekg/dns miekg-dns-*.tar.gz
	_golang-include-src github.com/opencontainers/runc opencontainers-runc-*.tar.gz
	_golang-include-src github.com/spf13/cobra spf13-cobra-*.tar.gz
	_golang-include-src github.com/spf13/pflag spf13-pflag-*.tar.gz
	_golang-include-src golang.org/x/net golang-net-*.tar.gz
}

src_prepare() {
	default
	sed -i -e "s/VERSION string = \"\"/VERSION string =\"${PV}\"/" src/${EGO_PN%/*}/main.go || die
}

src_compile() {
	CGO_LDFLAGS="-fno-PIC" GOPATH="${S}" go install -v -work "${EGO_PN}" || die
}

src_install() {
	dobin bin/${PN}
	pushd src/${EGO_PN%/*} || die
	dodoc README.md
	popd || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
