# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

case ${PV} in
	*_pre*) MY_P="${PN}${PV/_pre/dev.}" ;;
	*_rc*)  MY_P="${PN}${PV/_rc/pre.}" ;;
	*_p*|*) MY_P="${PN}${PV/_p/rel.}" ;;
esac

DESCRIPTION="An excellent console-based web browser with ssl support"
HOMEPAGE="https://lynx.invisible-island.net/"
SRC_URI="https://invisible-island.net/archives/lynx/tarballs/${MY_P}.tar.bz2"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/lynx/tarballs/${MY_P}.tar.bz2.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="brotli bzip2 cjk gnutls idn nls ssl"

RDEPEND="
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/zlib
	brotli? ( app-arch/brotli:= )
	bzip2? ( app-arch/bzip2 )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
	ssl? (
		!gnutls? (
			dev-libs/openssl:=
		)
		gnutls? (
			dev-libs/libgcrypt:=
			>=net-libs/gnutls-2.6.4:=
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	verify-sig? ( >=sec-keys/openpgp-keys-thomasdickey-20240114 )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-mint.patch"
	"${FILESDIR}/${PN}-2.9.0-parallel.patch"
)

QA_CONFIG_IMPL_DECL_SKIP=(
	arc4random # missing on musl but it handles it fine
	arc4random_push # doesn't exist on Linux
)

src_configure() {
	local myconf=(
		--enable-cgi-links
		--enable-color-style
		--enable-externs
		--enable-file-upload
		--enable-included-msgs
		--enable-ipv6
		--enable-nested-tables
		--enable-nsl-fork
		--enable-persistent-cookies
		--enable-prettysrc
		--enable-read-eta
		--enable-scrollbar
		--with-screen=ncursesw
		--with-zlib
		$(use_enable cjk)
		$(use_enable idn idna)
		$(use_enable nls)
		$(use_with brotli)
		$(use_with bzip2 bzlib)
	)

	if use ssl; then
		myconf+=(
			--with-$(usex gnutls gnutls ssl)="${EPREFIX}/usr"
		)
	fi

	econf "${myconf[@]}"

	# Compared to openssl gnutls-openssl API does not use
	# default trust store: bug #604526.
	sed -e \
		"s|#define SSL_CERT_FILE NULL|#define SSL_CERT_FILE \"${EPREFIX}/etc/ssl/certs/ca-certificates.crt\"|" \
		-i userdefs.h || die
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
	sed -i '/^#CHARACTER_SET:/ c\CHARACTER_SET:utf-8' \
			"${ED}"/etc/lynx.cfg || die "lynx.cfg not found"

	dodoc CHANGES COPYHEADER PROBLEMS README
	dodoc -r docs lynx_help
}
