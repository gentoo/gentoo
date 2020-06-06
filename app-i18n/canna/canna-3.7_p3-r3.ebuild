# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools cannadic toolchain-funcs

MY_P="Canna${PV//[._]/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/9565/${MY_P}.tar.bz2"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="canuum doc ipv6"

RDEPEND="canuum? (
		dev-libs/libspt
		sys-libs/ncurses:=
	)"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake
	canuum? ( virtual/pkgconfig )
	doc? (
		app-text/ghostscript-gpl
		dev-texlive/texlive-langjapanese
		dev-texlive/texlive-latexrecommended
	)"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-canuum.patch
	"${FILESDIR}"/${PN}-kpdef.patch
	"${FILESDIR}"/${PN}-overflow.patch
	"${FILESDIR}"/${PN}-posix-sort.patch
	"${FILESDIR}"/${PN}-Wformat.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)
DOCS="*CHANGES* ChangeLog INSTALL* README* RKCCONF* WHATIS*"

src_prepare() {
	default

	sed -i \
		-e "/DefLibCannaDir/s:/lib$:/$(get_libdir):" \
		-e "/UseInet6/s:0:$(usex ipv6 1 0):" \
		${PN^c}.conf

	if use canuum; then
		cd canuum
		mv configure.{in,ac}
		eautoreconf
		cd - > /dev/null
	fi
}

src_configure() {
	xmkmf -a || die

	if use canuum; then
		cd canuum
		xmkmf -a || die
		# workaround for sys-libs/ncurses[tinfo]
		sed -i "/^TERMCAP_LIB/s:=.*:=$(pkg-config --libs ncurses):" Makefile
		cd - > /dev/null
	fi

	if use doc; then
		cd doc/man/guide/tex
		xmkmf -a || die
		cd - > /dev/null
	fi
}

src_compile() {
	# bug #279706
	emake -j1 \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		SHLIBGLOBALSFLAGS="${LDFLAGS}" \
		${PN}

	if use canuum; then
		einfo "Compiling canuum"
		emake -C canuum -j1 \
			CC="$(tc-getCC)" \
			CDEBUGFLAGS="${CFLAGS}" \
			LOCAL_LDFLAGS="${LDFLAGS}" \
			canuum
	fi

	if use doc; then
		# NOTE: build fails if infinality enabled in fontconfig
		einfo "Compiling DVI, PS, and PDF documents"
		# bug #223077
		emake -C doc/man/guide/tex -j1 \
			JLATEXCMD="platex -kanji=euc" \
			DVI2PSCMD="dvips" \
			VARTEXFONTS="${T}"/fonts \
			${PN}.ps \
			${PN}.pdf
	fi
}

src_install() {
	emake DESTDIR="${D}" install install.man
	einstalldocs

	if use canuum; then
		emake -C canuum DESTDIR="${D}" install install.man
		docinto canuum
		dodoc README.jp
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/man/guide/tex/${PN}.{dvi,ps,pdf}
	fi

	# for backward compatibility
	dosbin "${FILESDIR}"/update-canna-dics_dir

	keepdir /var/lib/${PN}/dic/{user,group}
	fowners bin:bin /var/lib/${PN}/dic/{user,group}
	fperms 0775 /var/lib/${PN}/dic/{user,group}

	insinto /var/lib/${PN}/dic/dics.d
	newins "${ED}"/var/lib/${PN}/dic/${PN}/dics.dir 00${PN}.dics.dir

	keepdir /var/log/${PN}

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc
	newins "${FILESDIR}"/${PN}.hosts hosts.${PN}
}

pkg_postinst() {
	update-cannadic-dir

	if ! locale -a | grep -iq "ja_JP.eucjp"; then
		elog "Some dictionary tools in this package require ja_JP.EUC-JP locale."
		elog
		elog "# echo 'ja_JP.EUC-JP EUC-JP' >> /etc/locale.gen"
		elog "# locale-gen"
		elog
	fi
}
