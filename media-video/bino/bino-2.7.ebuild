# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/martinlambers.asc
inherit cmake verify-sig xdg

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="https://bino3d.org/"
SRC_URI="
	https://bino3d.org/releases/${P}.tar.gz
	verify-sig? ( https://bino3d.org/releases/${P}.tar.gz.sig )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

# for -gles2-only see https://bugs.gentoo.org/913873
RDEPEND="
	dev-qt/qtbase:6[-gles2-only,gui,opengl,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pandoc
	verify-sig? ( sec-keys/openpgp-keys-martinlambers )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7-unforce_lto.patch
)

src_configure() {
	local mycmakeargs=(
		# Unpackaged
		-DCMAKE_DISABLE_FIND_PACKAGE_QVR=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}
