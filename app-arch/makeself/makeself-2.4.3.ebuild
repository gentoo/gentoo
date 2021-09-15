# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Shell script that generates a self-extractible tar.gz"
HOMEPAGE="https://makeself.io/"
SRC_URI="https://github.com/megastep/makeself/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~amd64-linux ~x86-linux"

src_prepare() {
	default
	rm Makefile || die
}

src_install() {
	dobin makeself-header.sh makeself.sh
	dosym makeself.sh /usr/bin/makeself
	doman makeself.1
	dodoc README.md makeself.lsm
}

pkg_postinst() {
	optfeature "lz4 support" app-arch/lz4
	optfeature "lzop support" app-arch/lzop
	optfeature "pbzip2 support" app-arch/pbzip2
	optfeature "pigz support" app-arch/pigz
	optfeature "zstd support" app-arch/zstd

	# Also bzip2 and xz are supported but they are in @system.
}
