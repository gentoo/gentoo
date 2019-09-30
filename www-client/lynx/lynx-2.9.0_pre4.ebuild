# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# VERSIONING SCHEME TRANSLATION
# Upstream	:	Gentoo
# rel.		:	_p
# pre.		:	_rc
# dev.		:	_pre

case ${PV} in
	*_pre*) MY_P="${PN}${PV/_pre/dev.}" ;;
	*_rc*)  MY_P="${PN}${PV/_rc/pre.}" ;;
	*_p*|*) MY_P="${PN}${PV/_p/rel.}" ;;
esac

DESCRIPTION="An excellent console-based web browser with ssl support"
HOMEPAGE="https://lynx.invisible-island.net/"
SRC_URI="https://invisible-mirror.net/archives/lynx/tarballs/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 cjk gnutls idn ipv6 nls ssl unicode libressl"

RDEPEND="
	sys-libs/ncurses:0=[unicode?]
	sys-libs/zlib
	nls? ( virtual/libintl )
	ssl? (
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
		gnutls? (
			dev-libs/libgcrypt:0=
			>=net-libs/gnutls-2.6.4:=
		)
	)
	bzip2? ( app-arch/bzip2 )
	idn? ( net-dns/libidn:0= )
"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.6-mint.patch
	"${FILESDIR}"/${PN}-2.8.9_p1-parallel.patch
)

pkg_setup() {
	! use ssl && elog "SSL support disabled; you will not be able to access secure websites."
}

src_configure() {
	local myconf=(
		--enable-nested-tables
		--enable-cgi-links
		--enable-persistent-cookies
		--enable-prettysrc
		--enable-nsl-fork
		--enable-file-upload
		--enable-read-eta
		--enable-color-style
		--enable-scrollbar
		--enable-included-msgs
		--enable-externs
		--with-zlib
		$(use_enable nls)
		$(use_enable idn idna)
		$(use_enable ipv6)
		$(use_enable cjk)
		$(use_enable unicode japanese-utf8)
		$(use_with bzip2 bzlib)
		$(usex ssl "--with-$(usex gnutls gnutls ssl)=${EPREFIX}/usr" "")
		--with-screen=$(usex unicode "ncursesw" "ncurses")
	)

	econf "${myconf[@]}"
}

src_compile() {
	# generating translation files in parallel is currently broken
	use nls && emake -C po -j1
	emake
}

src_install() {
	emake install DESTDIR="${D}"

	sed -i "s|^HELPFILE.*$|HELPFILE:file://localhost/usr/share/doc/${PF}/lynx_help/lynx_help_main.html|" \
			"${ED}"/etc/lynx.cfg || die "lynx.cfg not found"
	if use unicode ; then
		sed -i '/^#CHARACTER_SET:/ c\CHARACTER_SET:utf-8' \
				"${ED}"/etc/lynx.cfg || die "lynx.cfg not found"
	fi

	dodoc CHANGES COPYHEADER PROBLEMS README
	dodoc -r docs lynx_help
}
