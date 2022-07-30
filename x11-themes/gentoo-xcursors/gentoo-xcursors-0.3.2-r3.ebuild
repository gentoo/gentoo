# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A high quality set of animated mouse cursors"
HOMEPAGE="https://schlomp.space/tastytea/gentoo-xcursors"
SRC_URI="https://schlomp.space/tastytea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

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

pkg_preinst() {
	# Needed until bug #834600 is solved
	if [[ -n ${REPLACING_VERSIONS} ]] ; then
		GENTOOCURSORS="${EROOT}/usr/share/cursors/xorg-x11"
		if [[ -d "${GENTOOCURSORS}/gentoo" ]] ; then
			rm -r "${GENTOOCURSORS}/gentoo" || die
		fi
		if [[ -d "${GENTOOCURSORS}/gentoo-blue" ]] ; then
			rm -r "${GENTOOCURSORS}/gentoo-blue" || die
		fi
		if [[ -d "${GENTOOCURSORS}/gentoo-silver" ]] ; then
			rm -r "${GENTOOCURSORS}/gentoo-silver" || die
		fi

		if [[ -L "${GENTOOCURSORS}"/gentoo.backup.0000 ]]; then
			einfo "There are symlinks left from a previous failed upgrade."
			einfo "Remove ${GENTOOCURSORS}/gentoo*.backup.* manually to get rid of them."
		fi
	fi
}

pkg_postinst() {
	einfo "To use this set of cursors, consult <https://wiki.gentoo.org/wiki/Cursor_themes>."
	einfo "The three sets installed are gentoo, gentoo-silver and gentoo-blue."
}
