# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kbd/kbd-2.0.1.ebuild,v 1.4 2015/07/14 03:40:55 vapier Exp $

EAPI="5"

inherit autotools eutils

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="http://kbd-project.org/"
SRC_URI="ftp://ftp.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls pam test"

RDEPEND="pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_unpack() {
	default
	cd "${S}"

	# broken file ... upstream git punted it
	rm po/es.po

	# Rename conflicting keymaps to have unique names, bug #293228
	cd "${S}"/data/keymaps/i386
	mv dvorak/no.map dvorak/no-dvorak.map
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map
	mv olpc/es.map olpc/es-olpc.map
	mv olpc/pt.map olpc/pt-olpc.map
	mv qwerty/cz.map qwerty/cz-qwerty.map
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.0-tests.patch #485116
	epatch "${FILESDIR}"/${P}-stdarg.patch #497200
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable pam vlock) \
		$(use_enable test tests)
}

src_install() {
	default
	dohtml docs/doc/*.html
}
