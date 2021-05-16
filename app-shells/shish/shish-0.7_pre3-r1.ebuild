# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The diet shell"
HOMEPAGE="http://www.blah.ch/shish/"
SRC_URI="http://www.blah.ch/${PN}/pkg/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug diet"

DEPEND="diet? ( dev-libs/dietlibc )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

src_prepare() {
	default

	# Respect CFLAGS, bug #439974
	sed -i \
		-e '/CFLAGS="$CFLAGS/d' \
		-e '/-fexpensive-optimizations -fomit-frame-pointer/d' \
		configure || die 'sed on configure failed'
}

src_configure() {
	use diet && export CC="diet $(tc-getCC) -nostdinc"

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
	einfo "Updating ${EROOT}/etc/shells"
	( grep -v "^/bin/shish$" "${EROOT}"/etc/shells; echo "/bin/shish" ) > "${T}"/shells
	mv -f "${T}"/shells "${EROOT}"/etc/shells
}
