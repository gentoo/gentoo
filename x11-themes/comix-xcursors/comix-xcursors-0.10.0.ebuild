# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ComixCursors"

DESCRIPTION="X11 mouse theme with a comics feeling"
HOMEPAGE="
	https://limitland.de/comixcursors
	https://gitlab.com/limitland/comixcursors
"
SRC_URI="
	https://limitland.gitlab.io/comixcursors/${MY_PN}-${PV}.tar.bz2
	lefthanded? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-LH-${PV}.tar.bz2 )
	opaque? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-Opaque-${PV}.tar.bz2 )
	lefthanded? ( opaque? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-LH-Opaque-${PV}.tar.bz2 ) )
"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86"
IUSE="lefthanded opaque"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/icons
	doins -r "${S}"/*

	CURSOR_NAMES=()
	for name in "${S}"/ComixCursors-* ; do
		dosym -r "/usr/share/icons/${name##${S}/}/cursors" "/usr/share/cursors/xorg-x11/${name##${S}}"
		CURSOR_NAMES+=( "${name##${S}/}" )
	done
}

pkg_preinst() {
	# Needed until bug #834600 is solved
	local name
	for name in "${CURSOR_NAMES[@]}" ; do
		if [[ -d "${EROOT}/usr/share/cursors/xorg-x11/${name}" ]] ; then
			rm -r "${EROOT}/usr/share/cursors/xorg-x11/${name}" || die
		fi
	done
}
