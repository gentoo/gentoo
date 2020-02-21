# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module golang-build systemd

DESCRIPTION="Main implementation of IPFS"
HOMEPAGE="https://ipfs.io/"
SRC_URI="https://dist.ipfs.io/go-ipfs/v${PV}/go-ipfs-source.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/ipfs/go-ipfs/v${PV}/misc/completion/ipfs-completion.bash -> ${P}.bash"
EGO_PN="github.com/ipfs/go-ipfs"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!net-p2p/go-ipfs-bin
	acct-group/ipfs
	acct-user/ipfs
	sys-fs/fuse:0
"

S="${WORKDIR}"

DOCS=(CHANGELOG.md CONTRIBUTING.md README.md docs/)

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
	)

	go build "${mygoargs[@]}" -o ipfs ${EGO_PN}/cmd/ipfs || die
	go build "${mygoargs[@]}" -o ipfswatch ${EGO_PN}/cmd/ipfswatch || die
}

src_test() {
	go test ${EGO_PN}/cmd/ipfs/... ${EGO_PN}/cmd/ipfswatch/... || die
}

src_install() {
	dobin ipfs
	dobin ipfswatch

	einstalldocs

	systemd_dounit "${FILESDIR}/ipfs.service"
	systemd_newunit "${FILESDIR}/ipfs-at.service" "ipfs@.service"

	newinitd "${FILESDIR}/ipfs.init" ipfs
	newconfd "${FILESDIR}/ipfs.confd" ipfs

	newbashcomp "${DISTDIR}/${P}.bash" "ipfs"
	keepdir /var/log/ipfs
}

pkg_preinst() {
	fowners -R ipfs:ipfs /var/log/ipfs
}

pkg_postinst() {
	elog 'To be able to use the ipfs service you will need to create the ipfs repository'
	elog '(eg: su -s /bin/sh -c "ipfs init -e" ipfs)'
	elog 'or change IPFS_PATH of /etc/conf.d/ipfs with another with proper permissions.'
}
