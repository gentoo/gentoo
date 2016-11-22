# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NEUTRAL_PN="Neutral"
NEUTRAL_PV="1.13a"		# 2006-03-06
NEUTRAL_P="${NEUTRAL_PN}-${NEUTRAL_PV}"

PLUS_PN="Neutral_Plus"
PLUS_PV="1.2"			# 2007-06-23
PLUS_P="${PLUS_PN}-${PLUS_PV}"

PLUSPLUS_PN="Neutral++"
PLUSPLUS_PV="1.0.3"		# 2015-01-06
PLUSPLUS_P="${PLUSPLUS_PN}-${PLUSPLUS_PV}"

WHITE_PN="Neutral++_White"
WHITE_PV="1.1.1"		# 2015-01-06
WHITE_P="${WHITE_PN}-${WHITE_PV}"

inherit gnome2-utils vcs-snapshot

DESCRIPTION="A family of smoothed and shadowed cursors that resemble the standard X ones"
HOMEPAGE="
	https://opendesktop.org/content/show.php/Neutral?content=28310
	https://opendesktop.org/content/show.php/Neutral+Plus?content=48837
	https://opendesktop.org/content/show.php/Neutral%2B%2B?content=108142
	https://opendesktop.org/content/show.php/Neutral%2B%2B+White?content=108143
"
# Neutral++{,_White} URIs return tar.xz archives that are actually tar.bz2.
SRC_URI="
	https://opendesktop.org/CONTENT/content-files/28310-neutral-${NEUTRAL_PV}.tar.gz -> ${NEUTRAL_P}.tar.gz
	https://opendesktop.org/CONTENT/content-files/48837-Neutral_Plus_${PLUS_PV}.tar.bz2 -> ${PLUS_P}.tar.bz2
	https://opendesktop.org/CONTENT/content-files/108142-Neutral++-${PLUSPLUS_PV}.tar.xz -> ${PLUSPLUS_P}.tar.bz2
	https://opendesktop.org/CONTENT/content-files/108143-Neutral++_White-${WHITE_PV}.tar.xz -> ${WHITE_P}.tar.bz2
"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-apps/xcursorgen"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_prepare() {
	default_src_prepare
	sed -i -e 's|neutral|Neutral|g' ${NEUTRAL_P}/index.theme || die
	mkdir -p ${PLUS_P}/source/cursors || die
}

src_compile() {
	local cursor_dir
	for cursor_dir in ${NEUTRAL_P} ${PLUS_P} ${PLUSPLUS_P} ${WHITE_P}; do
		pushd ${cursor_dir}/source > /dev/null || die
			sh make.sh || die
		popd > /dev/null || die
	done
}

src_install() {
	pushd ${NEUTRAL_P} > /dev/null || die
		insinto /usr/share/icons/${NEUTRAL_PN}
		doins -r index.theme source/cursors/
	popd > /dev/null || die

	pushd ${PLUS_P} > /dev/null || die
		insinto /usr/share/icons/${PLUS_PN}
		# Upstream ships an invalid (as per freedesktop.org) index.theme.
		# See https://www.freedesktop.org/wiki/Specifications/icon-theme-spec/
		doins -r "${FILESDIR}/index.theme" source/cursors/
	popd > /dev/null || die

	pushd ${PLUSPLUS_P} > /dev/null || die
		insinto /usr/share/icons/${PLUSPLUS_PN}
		doins -r index.theme cursors/
	popd > /dev/null || die

	pushd ${WHITE_P} > /dev/null || die
		insinto /usr/share/icons/${WHITE_PN}
		doins -r index.theme cursors/
	popd > /dev/null || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
