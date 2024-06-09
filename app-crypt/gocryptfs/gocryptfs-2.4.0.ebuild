# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://github.com/rfjakob/gocryptfs"
SRC_URI="https://github.com/rfjakob/gocryptfs/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz"
S=${WORKDIR}/${PN}_v${PV}_src-deps
LICENSE="MIT"
LICENSE+=" Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"
BDEPEND="virtual/pandoc"
PROPERTIES="test_privileged"
RESTRICT="test"

src_prepare() {
	default
	sed -e 's:ldd gocryptfs 2> /dev/null:! ldd gocryptfs | grep -q "statically linked":' \
		-i "${S}/build-without-openssl.bash" || die
}

src_compile() {
	emake build
}

src_install() {
	emake "DESTDIR=${ED}" install
	dobin contrib/statfs/statfs
	doman Documentation/*.1
	dodoc -r README.md Documentation
	rm -f "${ED}"/usr/share/doc/${PF}/Documentation/{.gitignore,gocryptfs.1,gocryptfs-xray.1,statfs.1,MANPAGE-render.bash} || die
}

src_test() {
	emake test
}
