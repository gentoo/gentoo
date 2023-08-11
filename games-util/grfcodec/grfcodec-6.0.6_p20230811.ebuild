# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

COMMIT=d5a7b850bcef30c0bfd17ceeb4a18c431770f468

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="https://github.com/OpenTTD/grfcodec"
SRC_URI="https://github.com/OpenTTD/grfcodec/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}
	dev-libs/boost"

PATCHES=(
	# Bug #894648
	"${FILESDIR}"/${P}-no-fortify-source.patch
)

src_configure() {
	local mycmakeargs=(
		# Make sure we don't use git by accident.
		# Build system does not care much if it's
		# executed successfully and populates
		# YEARS / VERSION with empty values.
		-DGIT_EXECUTABLE=/bin/do-not-use-git-executable
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/{grfcodec,grfid,grfstrip,nforenum}
	doman docs/*.1
	dodoc changelog.txt docs/*.txt
}
