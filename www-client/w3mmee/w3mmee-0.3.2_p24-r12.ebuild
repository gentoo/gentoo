# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit alternatives multilib toolchain-funcs

MY_PV="${PV##*_}-23"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A variant of w3m with support for multiple character encodings"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/w3mmee/"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${MY_P}.tar.gz"

SLOT="0"
LICENSE="w3m"
KEYWORDS="amd64 ppc ~riscv x86"
IUSE="gpm nls ssl"

DEPEND=">=dev-libs/boehm-gc-7.2
	dev-libs/libmoe
	dev-lang/perl
	sys-libs/ncurses:0=
	sys-libs/zlib
	gpm? ( sys-libs/gpm )
	nls? ( sys-devel/gettext )
	ssl? (
		dev-libs/openssl:0=
	)"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-boehm-gc.patch
	"${FILESDIR}"/${PN}-gcc-4.4.patch
	"${FILESDIR}"/${PN}-gcc-4.5.patch
	"${FILESDIR}"/${PN}-gcc-10.patch
	"${FILESDIR}"/${PN}-glibc-2.14.patch
	"${FILESDIR}"/${PN}-openssl-1.1.patch
	"${FILESDIR}"/${PN}-rc_name.patch
	"${FILESDIR}"/${PN}-time.patch
	"${FILESDIR}"/${PN}-tinfo.patch
	"${FILESDIR}"/${PN}-w3mman.patch
)
DOCS=( ChangeLog NEWS{,.mee} README )
HTML_DOCS=( 00INCOMPATIBLE.html )

src_prepare() {
	default

	sed -i "s:/lib\([^a-z$]\):/$(get_libdir)\1:g" configure || die
	sed -i "/^AR=/s:ar:$(tc-getAR):" XMakefile || die
}

src_configure() {
	local myconf=(
		-locale_dir=$(usex nls "${EPREFIX}/usr/share/locale" '(NONE)')
	)
	local myuse=(
		display_code=E
		system_code=E
		use_ansi_color=y
		use_cookie=y
		use_history=y
		use_mouse=$(usex gpm y n)
	)

	if use ssl; then
		myconf+=(
			--ssl-includedir="${EPREFIX}/usr/include/openssl"
			--ssl-libdir="${EPREFIX}/usr/$(get_libdir)"
		)
		myuse+=(
			use_digest_auth=y
			use_ssl=y
			use_ssl_verify=y
		)
	else
		myuse+=( use_ssl=n )
	fi
	# bug #678910
	myuse+=( use_image=n )

	cat <<-EOF >> config.param
	lang=MANY
	accept_lang=en
	EOF

	env CC="$(tc-getCC)" "${myuse[@]}" ./configure \
		-nonstop \
		-prefix="${EPREFIX}/usr" \
		-suffix=mee \
		-auxbindir="${EPREFIX}/usr/$(get_libdir)/${PN}" \
		-libdir="${EPREFIX}/usr/$(get_libdir)/${PN}/cgi-bin" \
		-helpdir="${EPREFIX}/usr/share/${PN}" \
		-mandir="${EPREFIX}/usr/share/man" \
		-sysconfdir="${EPREFIX}/etc/${PN}" \
		-model=custom \
		-libmoe="${EPREFIX}/usr/$(get_libdir)" \
		-mb_h="${EPREFIX}/usr/include/moe" \
		-mk_btri="${EPREFIX}/usr/libexec/moe" \
		-cflags="${CFLAGS}" \
		-ldflags="${LDFLAGS}" \
		"${myconf[@]}" \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	# w3mman and manpages conflict with those from w3m
	mv "${ED}"/usr/share/man/man1/w3m{,mee}.1 || die
	mv "${ED}"/usr/share/man/ja/man1/w3m{,mee}.1 || die

	docinto html/en
	dodoc doc/*.html
	rm -f doc/*.html
	docinto en
	dodoc doc/{HISTORY,README,keymap,menu}*

	docinto html/ja
	dodoc doc-jp/*.html
	rm -f doc-jp/*.html
	docinto ja
	dodoc doc-jp/{HISTORY,README,keymap,menu}*
}

pkg_postinst() {
	w3m_alternatives
	einfo
	einfo "If you want to render multilingual text, please refer to"
	einfo "/usr/share/doc/${PF}/en/README.mee or"
	einfo "/usr/share/doc/${PF}/jp/README.mee"
	einfo "and set W3MLANG variable respectively."
	einfo
}

pkg_postrm() {
	w3m_alternatives
}

w3m_alternatives() {
	if [[ ! -f /usr/bin/w3m ]]; then
		alternatives_makesym /usr/bin/w3m \
			/usr/bin/w3m{m17n,mee}
		alternatives_makesym /usr/bin/w3mman \
			/usr/bin/w3m{man-m17n,meeman}
		alternatives_makesym /usr/share/man/ja/man1/w3m.1.gz \
			/usr/share/man/ja/man1/w3m{m17n,mee}.1.gz
		alternatives_makesym /usr/share/man/man1/w3m.1.gz \
			/usr/share/man/man1/w3m{m17n,mee}.1.gz
		alternatives_makesym /usr/share/man/man1/w3mman.1.gz \
			/usr/share/man/man1/w3m{man-m17n,meeman}.1.gz
	fi
}
