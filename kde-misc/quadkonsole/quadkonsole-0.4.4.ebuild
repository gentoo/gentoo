# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/quadkonsole/quadkonsole-0.4.4.ebuild,v 1.4 2015/06/04 18:57:34 kensington Exp $

EAPI=5

KDE_HANDBOOK=optional
KDE_LINGUAS_DIR="i18n"
KDE_LINGUAS="cs de sr sr@ijekavian sr@ijekavianlatin sr@latin"
inherit kde4-base

MY_P=${PN}4-${PV}

DESCRIPTION="Grid of Konsole terminals"
HOMEPAGE="http://kb.ccchl.de/quadkonsole4/"
SRC_URI="http://kb.ccchl.de/${PN}4/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep libkonq)
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )

S=${WORKDIR}/${MY_P}

src_prepare() {
	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			rm ${KDE_LINGUAS_DIR}/${PN}4_${lang}.po
		fi
	done

	kde4-base_src_prepare
}
