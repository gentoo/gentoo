# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KDE_LINGUAS="de en_GB es et fr km nds pl pt ru sv tr uk"
KDE_LINGUAS_DIR=( applet/locale containment/locale )
KDE_MINIMAL="4.8"
inherit kde4-base

DESCRIPTION="Task and launch representation plasmoid"
HOMEPAGE="http://kde-look.org/content/show.php/Fancy+Tasks?content=99737"
SRC_URI="http://kde-look.org/CONTENT/content-files/99737-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep plasma-workspace)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG README TODO )

src_prepare() {
	kde4-base_src_prepare

	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use "l10n_$(kde4_lingua_to_l10n "${lang}")" ; then
			local dir
			for dir in ${KDE_LINGUAS_DIR[@]} ; do
				if [ -f ${dir}/${lang}.mo ]; then
					rm ${dir}/${lang}.mo
				fi
			done
		fi
	done
}
