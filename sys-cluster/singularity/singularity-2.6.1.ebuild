# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit autotools eutils python-single-r1

DESCRIPTION="Application containers for Linux"
HOMEPAGE="https://sylabs.io"
SRC_URI="https://github.com/${PN}ware/${PN}/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs +suid"

RDEPEND="
	sys-fs/squashfs-tools:0
"

src_prepare() {
	default
	# automake version hardcoding
	eautoreconf
}

src_configure() {
	econf \
		--with-userns \
		$(usex suid "" "--disable-suid") \
		$(use_enable static-libs static)
}

src_install() {
	MAKEOPTS+=" -j1"
	default
	dodoc README.md CONTRIBUTORS.md CONTRIBUTING.md
	use examples && dodoc -r examples
}
