# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
EGO_PN="github.com/cesanta/docker_auth/..."

inherit user golang-build golang-vcs-snapshot

SHORT_COMMIT="99a7306"
SRC_URI="https://${EGO_PN%/*}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dchest/uniuri/archive/8902c56451e9b58ff940bbe5fec35d5f9c04584a.tar.gz -> dchest-uniuri-8902c56451e9b58ff940bbe5fec35d5f9c04584a.tar.gz
	https://github.com/deckarep/golang-set/archive/ceca0031971f0401859beb9fc7396188545e4c9f.tar.gz -> deckarep-golang-set-ceca0031971f0401859beb9fc7396188545e4c9f.tar.gz
	https://github.com/docker/distribution/archive/314144ac0bdb35c759a63eed71cda272b7bbddff.tar.gz -> docker-distribution-314144ac0bdb35c759a63eed71cda272b7bbddff.tar.gz
	https://github.com/docker/libtrust/archive/aabc10ec26b754e797f9028f4589c5b7bd90dc20.tar.gz -> docker-libtrust-aabc10ec26b754e797f9028f4589c5b7bd90dc20.tar.gz
	https://github.com/facebookgo/httpdown/archive/a3b1354551a26449fbe05f5d855937f6e7acbd71.tar.gz -> facebookgo-httpdown-a3b1354551a26449fbe05f5d855937f6e7acbd71.tar.gz
	https://github.com/facebookgo/clock/archive/600d898af40aa09a7a93ecb9265d87b0504b6f03.tar.gz -> facebookgo-clock-600d898af40aa09a7a93ecb9265d87b0504b6f03.tar.gz
	https://github.com/facebookgo/stats/archive/1b76add642e42c6ffba7211ad7b3939ce654526e.tar.gz -> facebookgo-stats-1b76add642e42c6ffba7211ad7b3939ce654526e.tar.gz
	https://github.com/go-ldap/ldap/archive/8168ee085ee43257585e50c6441aadf54ecb2c9f.tar.gz -> go-ldap-ldap-8168ee085ee43257585e50c6441aadf54ecb2c9f.tar.gz
	https://github.com/golang/glog/archive/23def4e6c14b4da8ac2ed8007337bc5eb5007998.tar.gz -> golang-glog-23def4e6c14b4da8ac2ed8007337bc5eb5007998.tar.gz
	https://github.com/syndtr/goleveldb/archive/6b4daa5362b502898ddf367c5c11deb9e7a5c727.tar.gz -> syndtr-goleveldb-6b4daa5362b502898ddf367c5c11deb9e7a5c727.tar.gz
	https://github.com/golang/snappy/archive/d9eb7a3d35ec988b8585d4a0068e462c27d28380.tar.gz -> golang-snappy-d9eb7a3d35ec988b8585d4a0068e462c27d28380.tar.gz
	https://github.com/go-asn1-ber/asn1-ber/archive/4e86f4367175e39f69d9358a5f17b4dda270378d.tar.gz -> go-asn1-ber-asn1-ber-4e86f4367175e39f69d9358a5f17b4dda270378d.tar.gz
	https://github.com/fsnotify/fsnotify/archive/629574ca2a5df945712d3079857300b5e4da0236.tar.gz -> fsnotify-fsnotify-629574ca2a5df945712d3079857300b5e4da0236.tar.gz
	https://github.com/go-mgo/mgo/archive/3f83fa5005286a7fe593b055f0d7771a7dce4655.tar.gz -> go-mgo-mgo-3f83fa5005286a7fe593b055f0d7771a7dce4655.tar.gz
	https://github.com/go-yaml/yaml/archive/a5b47d31c556af34a302ce5d659e6fea44d90de0.tar.gz -> go-yaml-yaml-a5b47d31c556af34a302ce5d659e6fea44d90de0.tar.gz
	https://github.com/golang/crypto/archive/453249f01cfeb54c3d549ddb75ff152ca243f9d8.tar.gz -> golang-crypto-453249f01cfeb54c3d549ddb75ff152ca243f9d8.tar.gz
	https://github.com/golang/sys/archive/075e574b89e4c2d22f2286a7e2b919519c6f3547.tar.gz -> golang-sys-075e574b89e4c2d22f2286a7e2b919519c6f3547.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="http://github.com/cesanta/docker_auth"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

_golang-include-src() {
	local VENDORPN=$1 TARBALL=$2
	mkdir -p "${WORKDIR}/${P}/src/${VENDORPN}" || die
	tar -C "${WORKDIR}/${P}/src/${VENDORPN}" -x --strip-components 1\
		-f "${DISTDIR}"/${TARBALL} || die
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_unpack() {
	golang-vcs-snapshot_src_unpack
	_golang-include-src github.com/dchest/uniuri dchest-uniuri*.tar.gz
	_golang-include-src github.com/deckarep/golang-set deckarep-golang-set*.tar.gz
	_golang-include-src github.com/docker/distribution docker-distribution*.tar.gz
	_golang-include-src github.com/docker/libtrust docker-libtrust*.tar.gz
	_golang-include-src github.com/facebookgo/httpdown facebookgo-httpdown-*.tar.gz
	_golang-include-src github.com/facebookgo/clock facebookgo-clock-*.tar.gz
	_golang-include-src github.com/facebookgo/stats facebookgo-stats-*.tar.gz
	_golang-include-src github.com/go-ldap/ldap go-ldap-ldap-*.tar.gz
	_golang-include-src github.com/golang/glog golang-glog-*.tar.gz
	_golang-include-src github.com/go-ldap/ldap go-ldap-ldap-*.tar.gz
	_golang-include-src github.com/syndtr/goleveldb syndtr-goleveldb-*.tar.gz
	_golang-include-src github.com/golang/snappy golang-snappy-*.tar.gz
	_golang-include-src gopkg.in/asn1-ber.v1 go-asn1-ber-asn1-ber-*.tar.gz
	_golang-include-src gopkg.in/fsnotify.v1 fsnotify-fsnotify-*.tar.gz
	_golang-include-src gopkg.in/mgo.v2 go-mgo-*.tar.gz
	_golang-include-src gopkg.in/yaml.v2 go-yaml-*.tar.gz
	_golang-include-src golang.org/x/crypto golang-crypto-*.tar.gz
	_golang-include-src golang.org/x/sys golang-sys-*.tar.gz
}

src_prepare() {
	default
	cp "${FILESDIR}/version.go" src/${EGO_PN%/*}/auth_server/version.go || die
	sed -i -e "s/{version}/${PV}/" -e "s/{build_id}/${SHORT_COMMIT}/" src/${EGO_PN%/*}/auth_server/version.go || die
}

src_compile() {
	pushd src/${EGO_PN%/*}/auth_server || die
	GOPATH="${WORKDIR}/${P}" go build -o "bin/auth_server" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dodoc README.md docs/Backend_MongoDB.md
	insinto /usr/share/${PF}
	doins -r examples
	insinto /etc/docker_auth/
	newins examples/reference.yml config.yml.example
	dobin auth_server/bin/auth_server
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	keepdir /var/log/docker_auth
	popd || die
}
