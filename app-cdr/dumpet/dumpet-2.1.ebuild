# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="A tool to dump and debug bootable CD-like images"
HOMEPAGE="https://github.com/rhboot/dumpet"
SRC_URI="http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/source/tree/Packages/d/dumpet-${PV}-15.fc27.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup(){
	tc-export CC
}

src_prepare() {
	use amd64 && eapply "${WORKDIR}"/0001-Manually-tell-it-we-ve-got-64-bit-files-because-32-b.patch
	default
}
