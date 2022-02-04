# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Apps for querying the sg SCSI interface"
HOMEPAGE="http://sg.danny.cz/sg/"
#SRC_URI="https://github.com/hreinecke/sg3_utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="http://sg.danny.cz/sg/p/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs"

DEPEND="sys-devel/libtool"
RDEPEND="!sys-apps/rescan-scsi-bus"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dodoc COVERAGE doc/README examples/*.txt
	newdoc scripts/README README.scripts

	find "${ED}" -type f -name "*.la" -delete || die

	# Better fix for bug 231089; some packages look for sgutils2
	local path lib
	path="/usr/$(get_libdir)"
	for lib in "${ED}/"${path}/libsgutils2{,-${PV}}.*; do
		lib=${lib##*/}
		dosym "${lib}" "${path}/${lib/libsgutils2/libsgutils}"
	done
}
