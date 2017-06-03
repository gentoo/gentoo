# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Utility for adding image files (e.g. album cover art) to metadata of FLAC files"
HOMEPAGE="http://www.singingtree.com/software/"
SRC_URI="http://www.singingtree.com/software/${PN}.tar.gz -> ${P}.tar.gz"
# FIXME: no version in tarball, but also no updates for a long time. So it's ok.

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/flac"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/${PN}-1.00-add-missing-string-include.patch
	"${FILESDIR}"/${PN}-1.00-fix-build-system.patch
)

src_configure() {
	# remove pre-compiled binary
	rm -f "${PN}" || die

	tc-export CC
}

src_install() {
	dobin "${PN}"
}
