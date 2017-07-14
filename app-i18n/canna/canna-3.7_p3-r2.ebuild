# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cannadic toolchain-funcs

MY_P="Canna${PV//[._]/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/canna/9565/${MY_P}.tar.bz2"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc ipv6"

DEPEND="x11-misc/gccmakedep
	x11-misc/imake
	doc? (
		app-text/ghostscript-gpl
		dev-texlive/texlive-langjapanese
		dev-texlive/texlive-latexrecommended
	)"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-kpdef.patch
	"${FILESDIR}"/${PN}-overflow.patch
	"${FILESDIR}"/${PN}-posix-sort.patch
	"${FILESDIR}"/${PN}-Wformat.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)
DOCS="*CHANGES* ChangeLog INSTALL* README* RKCCONF* WHATIS*"

src_prepare() {
	default

	find . -name '*.man' -o -name '*.jmn' | xargs sed -i.bak -e 's/1M/8/g' || die

	sed -i \
		-e "/DefLibCannaDir/s:/lib$:/$(get_libdir):" \
		-e "/UseInet6/s:0:$(usex ipv6 1 0):" \
		Canna.conf
}

src_configure() {
	xmkmf -a || die

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

	dodir /usr/share/man{,/ja}/man8
	local man mandir
	for man in cannaserver cannakill ; do
		for mandir in "${D}"/usr/share/man "${D}"/usr/share/man/ja ; do
			mv ${mandir}/man1/${man}.1 ${mandir}/man8/${man}.8
		done
	done

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
