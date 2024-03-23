# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Serviceability for SCSI Disks and Arrays"
HOMEPAGE="http://scsirastools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=sys-apps/sg3_utils-1.44"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-prefix.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	eautoreconf

	# remove pre-compiled binaries
	rm files/ialarms* || die
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/863719
	# Upstream sourceforge; dead for 6 years; no bug filed.
	filter-lto

	econf --sbindir=/usr/sbin
}

src_install() {
	default
	dosbin files/sgevt files/mdevt

	# install modepage files
	insinto /usr/share/${PN}
	doins files/*.mdf
}
