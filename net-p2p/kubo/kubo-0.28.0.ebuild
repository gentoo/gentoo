# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion systemd

DESCRIPTION="Main implementation of IPFS"
HOMEPAGE="https://ipfs.tech https://github.com/ipfs/kubo/"
SRC_URI="https://github.com/ipfs/${PN}/releases/download/v${PV}/kubo-source.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	acct-group/ipfs
	acct-user/ipfs
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md docs/ )

src_compile() {
	local mygoargs
	mygoargs=(
		-tags release
	)

	ego build "${mygoargs[@]}" -o ipfs ./cmd/ipfs
	ego build "${mygoargs[@]}" -o ipfswatch ./cmd/ipfswatch

	IPFS_PATH="" ./ipfs commands completion bash > ipfs-completion.bash || die
	IPFS_PATH="" ./ipfs commands completion fish > ipfs-completion.fish || die
	IPFS_PATH="" ./ipfs commands completion zsh > ipfs-completion.zsh || die
}

src_test() {
	ego test ./cmd/ipfs/... ./cmd/ipfswatch/...
}

src_install() {
	dobin ipfs
	dobin ipfswatch
	newbashcomp ipfs-completion.bash ipfs
	newfishcomp ipfs-completion.fish ipfs
	newzshcomp ipfs-completion.zsh _ipfs
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

	# See https://bugs.gentoo.org/838238
	ewarn 'In case kubo CPU usage is too high run the next workaround'
	ewarn 'su -s /bin/sh -c "ipfs config profile apply lowpower" ipfs'
	ewarn 'Be aware that this will make your node less visible to other peers'
}
