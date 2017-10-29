# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit autotools eutils python-single-r1

DESCRIPTION="Application containers for Linux"
HOMEPAGE="http://singularity.lbl.gov/"
SRC_URI="https://github.com/${PN}ware/${PN}/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="cctbx-2.0"
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
	prune_libtool_files
	dodoc ChangeLog CONTRIBUTORS.md CONTRIBUTING.md
	use examples && dodoc -r examples
}
