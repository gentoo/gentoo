# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utility for adding image files (e.g. album cover art) to metadata of FLAC files"
HOMEPAGE="http://www.singingtree.com/software/"
# FIXME: no version in tarball, but also no updates for a long time. So it's ok.
SRC_URI="http://www.singingtree.com/software/${PN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/flac:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.00-add-missing-string-include.patch
	"${FILESDIR}"/${PN}-1.00-fix-build-system.patch
)

src_configure() {
	tc-export CC

	# remove pre-compiled binary
	rm -f "${PN}" || die
}

src_install() {
	dobin "${PN}"
}
