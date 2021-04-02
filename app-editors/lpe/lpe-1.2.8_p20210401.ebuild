# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

COMMIT="203c88eae66c6a3bffd050286af6d9aacf85816e"
DESCRIPTION="A lightweight programmers editor"
HOMEPAGE="https://packages.qa.debian.org/l/lpe.html"
SRC_URI="https://github.com/AdamMajer/lpe/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-linux"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/slang
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
"

src_prepare() {
	default

	# You should add PKG_CHECK_MODULES(NCURSES, ncurses) to configure.in and
	# replace -lncurses in src/Makefile.am with $(NCURSES_LIBS)
	# That is, if you need eautoreconf
	sed -i \
		-e "s:-lncurses:$($(tc-getPKG_CONFIG) --libs-only-l ncurses):" \
		configure.ac || die

	# Actually use what configure discovers (above)
	# bug #779778
	sed -i \
		-e 's:-lncurses:@NCURSES_LIB@:' \
		src/Makefile.am || die

	# Refresh outdated libtool (elibtoolize insufficient)
	# Fixes undefined references on macOS/Darwin
	eautoreconf
}

src_configure() {
	econf \
		--without-included-gettext \
		$(use_enable nls)
}

src_install() {
	emake \
		libdir="${ED}/usr/$(get_libdir)" \
		prefix="${ED}/usr" \
		datadir="${ED}/usr/share" \
		mandir="${ED}/usr/share/man" \
		infodir="${ED}/usr/share/info" \
		docdir="${ED}/usr/share/doc/${PF}" \
		exdir="${ED}/usr/share/doc/${PF}/examples" \
		install

	find "${ED}" -name '*.la' -delete || die
}
