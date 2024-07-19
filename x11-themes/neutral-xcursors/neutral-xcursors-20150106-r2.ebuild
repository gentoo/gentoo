# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEUTRAL_PN="Neutral"
NEUTRAL_PV="1.13a"
NEUTRAL_P="${NEUTRAL_PN}-${NEUTRAL_PV}"

PLUS_PN="Neutral_Plus"
PLUS_PV="1.2"
PLUS_P="${PLUS_PN}-${PLUS_PV}"

PLUSPLUS_PN="Neutral++"
PLUSPLUS_PV="1.0.3"
PLUSPLUS_P="${PLUSPLUS_PN}-${PLUSPLUS_PV}"

WHITE_PN="Neutral++_White"
WHITE_PV="1.1.1"
WHITE_P="${WHITE_PN}-${WHITE_PV}"

DESCRIPTION="A family of smoothed and shadowed cursors that resemble the standard X ones"
HOMEPAGE="
	https://store.kde.org/p/999947/
	https://store.kde.org/p/999928/
	https://store.kde.org/p/999941/
	https://store.kde.org/p/999806/
"

SRC_URI="
	mirror://gentoo/${NEUTRAL_P}.tar.gz
	mirror://gentoo/${PLUS_P}.tar.bz2
	mirror://gentoo/${PLUSPLUS_P}.tar.bz2
	mirror://gentoo/${WHITE_P}.tar.bz2
"
S="${WORKDIR}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="x11-apps/xcursorgen"
RDEPEND="x11-libs/libXcursor"

src_prepare() {
	default

	mv neutral Neutral || die
	mkdir -p "${PLUS_PN}"/source/cursors || die
}

src_compile() {
	local cursor_dirs=( "${NEUTRAL_PN}" "${PLUS_PN}" "${PLUSPLUS_PN}" "${WHITE_PN}"	)
	for cursor_dir in "${cursor_dirs[@]}"; do
		pushd "${cursor_dir}"/source
			./make.sh || die
		popd
	done
}

src_install() {
	pushd "${NEUTRAL_PN}"
		insinto /usr/share/icons/"${NEUTRAL_PN}"
		doins -r index.theme source/cursors/
	popd

	pushd "${PLUS_PN}"
		insinto /usr/share/icons/"${PLUS_PN}"
		doins -r "${FILESDIR}/index.theme" source/cursors/
	popd

	pushd "${PLUSPLUS_PN}"
		insinto /usr/share/icons/"${PLUSPLUS_PN}"
		doins -r index.theme cursors/
	popd

	pushd "${WHITE_PN}"
		insinto /usr/share/icons/"${WHITE_PN}"
		doins -r index.theme cursors/
	popd
}
