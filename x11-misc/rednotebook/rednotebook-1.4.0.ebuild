# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/rednotebook/rednotebook-1.4.0.ebuild,v 1.4 2014/01/07 22:28:10 mattm Exp $

EAPI="3"

PYTHON_DEPEND="2"
LANGS="ar ast be bg bs ca cs cy da de el en_GB eo es eu fi fo fr gl he hr hu hy
id it ja ka kk ko lt mn ms nb nds nl nn oc pl pt pt_BR ro ru si sk sr sv ta te
tl tr ug uk uz vi wa zh_CN zh_HK zh_TW"

inherit python eutils distutils

DESCRIPTION="A graphical journal with calendar, templates, tags, keyword searching, and export functionality"
HOMEPAGE="http://rednotebook.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libyaml spell"
for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

RDEPEND="dev-python/pyyaml[libyaml?]
	>=dev-python/pygtk-2.13
	dev-python/pywebkitgtk
	spell? ( dev-python/gtkspell-python )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	! use spell && epatch "${FILESDIR}/${PN}-1.2.0-disable-spell.patch"
	# rename wae file. I think this should be wa.po instead of wae.po
	mv po/wae.po po/wa.po || die
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			rm po/${x}.po || die
		fi
	done
	distutils_src_prepare
}
