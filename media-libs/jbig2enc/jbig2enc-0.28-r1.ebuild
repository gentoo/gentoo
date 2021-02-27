# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="JBIG2 Encoder and libs"
HOMEPAGE="https://github.com/agl/jbig2enc"
SRC_URI="https://github.com/agl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos"
IUSE="gif jpeg png tiff webp"

RDEPEND="media-libs/leptonica[gif?,jpeg?,png?,tiff?,webp?]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-leptonica-1.70.patch"
)

src_prepare() {
	default

	# remove -Werror
	sed -i -e '/AM_INIT_AUTOMAKE/s/-Werror//' configure.ac || die 'sed on configure.ac failed'
	# prevent static linking and QA notice about insecure RUNPATHs
	sed -i -e '/jbig2_LDFLAGS/d' src/Makefile.am || die 'sed on src/Makefile.am failed'

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
