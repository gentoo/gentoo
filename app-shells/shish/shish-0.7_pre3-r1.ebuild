# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/shish/shish-0.7_pre3-r1.ebuild,v 1.1 2012/12/10 12:00:37 pinkbyte Exp $

EAPI=5

inherit toolchain-funcs

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The diet shell"
HOMEPAGE="http://www.blah.ch/shish/"
SRC_URI="http://www.blah.ch/${PN}/pkg/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug diet"

DEPEND="diet? ( dev-libs/dietlibc )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

pkg_setup() {
	use diet && export CC="diet $(tc-getCC) -nostdinc"
}

src_prepare() {
	# Respect CFLAGS, bug #439974
	sed -i \
		-e '/CFLAGS="$CFLAGS/d' \
		-e '/-fexpensive-optimizations -fomit-frame-pointer/d' \
		configure || die 'sed on configure failed'
}

src_configure() {
	econf \
		$(use_enable debug) \
		--disable-quiet # bug 439974
}

src_compile() {
	# parallel make is b0rked
	emake -j1
}

src_install() {
	default
	doman doc/man/shish.1
}

pkg_postinst() {
	einfo "Updating ${ROOT}etc/shells"
	( grep -v "^/bin/shish$" "${ROOT}"etc/shells; echo "/bin/shish" ) > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"etc/shells
}
