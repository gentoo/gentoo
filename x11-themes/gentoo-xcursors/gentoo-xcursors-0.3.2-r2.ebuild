# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A high quality set of animated mouse cursors"
HOMEPAGE="https://schlomp.space/tastytea/gentoo-xcursors"
SRC_URI="https://schlomp.space/tastytea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

src_install() {
	insinto /usr/share/icons
	doins -r cursors/*

	# Add symlinks in Gentoo-specific location for backwards compatibility, #848606
	mkdir -p ${ED}/usr/share/cursors/xorg-x11 || die
	cd ${ED}/usr/share/cursors/xorg-x11 || die
	for cursorset in ../../icons/*; do
		dosym ${cursorset} /usr/share/cursors/xorg-x11/${cursorset##*/}
	done
}

pkg_postinst() {
	einfo "To use this set of cursors, consult <https://wiki.gentoo.org/wiki/Cursor_themes>."
	einfo "The three sets installed are gentoo, gentoo-silver and gentoo-blue."
}
