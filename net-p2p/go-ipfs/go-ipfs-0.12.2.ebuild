# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module systemd

DESCRIPTION="Main implementation of IPFS"
HOMEPAGE="https://ipfs.io/"
SRC_URI="https://github.com/ipfs/go-ipfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!net-p2p/go-ipfs-bin
	acct-group/ipfs
	acct-user/ipfs
	sys-fs/fuse:0
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md docs/ )

PATCHES=(
	# Should be able to drop once https://github.com/ipfs/go-ipfs/issues/8819 is fixed
	# Needed for Go 1.18 compatibility
	"${FILESDIR}"/${PN}-0.12.2-upgrade-quic-go.patch
)

src_compile() {
	default

	local mygoargs
	mygoargs=(
		-tags release
	)

	go build "${mygoargs[@]}" -o ipfs ./cmd/ipfs || die
	go build "${mygoargs[@]}" -o ipfswatch ./cmd/ipfswatch || die

	./ipfs commands completion bash > ipfs-completion.bash || die
}

src_test() {
	go test ./cmd/ipfs/... ./cmd/ipfswatch/... || die
}

src_install() {
	dobin ipfs
	dobin ipfswatch
	newbashcomp ipfs-completion.bash ipfs
	einstalldocs

	systemd_dounit "${FILESDIR}/ipfs.service"
	systemd_newunit "${FILESDIR}/ipfs-at.service" "ipfs@.service"

	newinitd "${FILESDIR}/ipfs.init" ipfs
	newconfd "${FILESDIR}/ipfs.confd" ipfs

	keepdir /var/log/ipfs
	fowners -R ipfs:ipfs /var/log/ipfs
}

pkg_postinst() {
	elog 'To be able to use the ipfs service you will need to create the ipfs repository'
	elog '(eg: su -s /bin/sh -c "ipfs init -e" ipfs)'
	elog 'or change IPFS_PATH of /etc/conf.d/ipfs with another with proper permissions.'
}
