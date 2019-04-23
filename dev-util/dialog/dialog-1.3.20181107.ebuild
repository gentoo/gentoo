# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib versionator

DIA_P="${PN}-$(replace_version_separator 2 '-')"
DESCRIPTION="tool to display dialog boxes from a shell"
HOMEPAGE="https://invisible-island.net/dialog/"
SRC_URI="https://dev.gentoo.org/~jer/${DIA_P}.tgz"

LICENSE="GPL-2"
SLOT="0/15"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="examples minimal nls static-libs unicode"

RDEPEND="
	>=sys-libs/ncurses-5.2-r5:=[unicode?]
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	!minimal? ( sys-devel/libtool )
	!<=sys-freebsd/freebsd-contrib-8.9999
"
S=${WORKDIR}/${DIA_P}

src_prepare() {
	default
	sed -i -e '/LIB_CREATE=/s:${CC}:& ${LDFLAGS}:g' configure || die
	sed -i '/$(LIBTOOL_COMPILE)/s:$: $(LIBTOOL_OPTS):' makefile.in || die
}

src_configure() {
	econf \
		--disable-rpath-hack \
		$(use_enable nls) \
		$(use_with !minimal libtool) \
		--with-libtool-opts=$(usex static-libs '' '-shared') \
		--with-ncurses$(usex unicode w '')
}

src_install() {
	use minimal && default || emake DESTDIR="${D}" install-full

	use examples && dodoc -r samples

	dodoc CHANGES README

	prune_libtool_files
}
