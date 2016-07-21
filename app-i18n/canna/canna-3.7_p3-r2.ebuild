# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit cannadic eutils multilib

MY_P="Canna${PV//./}"
MY_P="${MY_P/_/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/canna/9565/${MY_P}.tar.bz2"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND=">=sys-apps/sed-4
	x11-misc/gccmakedep
	x11-misc/imake
	doc? (
		app-text/ghostscript-gpl
		>=dev-texlive/texlive-langcjk-2010
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-genericrecommended
		dev-texlive/texlive-latexrecommended
	)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	find . -name '*.man' -o -name '*.jmn' | xargs sed -i.bak -e 's/1M/8/g' || die
	sed -e "s%@cannapkgver@%${PF}%" \
		"${FILESDIR}"/${PN}-3.7-gentoo.diff.in > "${T}"/${PF}-gentoo.diff || die
	epatch "${T}"/${PF}-gentoo.diff

	# bug #248723
	epatch "${FILESDIR}"/${P}-strip.patch

	# Multilib-strict fix for amd64
	sed -i -e "s:\(DefLibCannaDir.*\)/lib:\1/$(get_libdir):g" Canna.conf* || die
	# fix deprecated sort syntax
	sed -e 's:^\(sortcmd=\".* -s\).*$:\1 -k 1,1\":' \
		-i cmd/mkbindic/mkbindic.cpp || die

	cd "${S}"/dic/phono
	epatch "${FILESDIR}"/${PN}-kpdef-gentoo.diff

}

src_compile() {
	xmkmf || die

	#make libCannaDir=../lib/canna canna || die
	# bug #279706
	emake -j1 CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" SHLIBGLOBALSFLAGS="${LDFLAGS}" canna || die

	if use doc ; then
		einfo "Compiling DVI, PS (and PDF) document"
		cd doc/man/guide/tex
		xmkmf || die
		emake -j1 CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
			LOCAL_LDFLAGS="${LDFLAGS}" SHLIBGLOBALSFLAGS="${LDFLAGS}" \
			JLATEXCMD=platex \
			DVI2PSCMD="dvips -f" VARTEXFONTS="${T}"/fonts \
			canna.dvi canna.ps || die
		if has_version 'app-text/dvipdfmx' && \
			( has_version 'app-text/acroread' \
			|| has_version 'app-text/xpdf-japanese' ); then
			emake -j1 CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
				LOCAL_LDFLAGS="${LDFLAGS}" SHLIBGLOBALSFLAGS="${LDFLAGS}" \
				JLATEXCMD=platex \
				DVI2PSCMD="dvips -f" VARTEXFONTS="${T}"/fonts \
				canna.pdf || die
		fi
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	emake DESTDIR="${D}" install.man || die

	# install default.canna (removed from Canna36p4)
	insinto /usr/share/canna
	newins misc/initfiles/verbose.canna default.canna

	# cannakill should link to /usr/bin/catdic
	dosym ../bin/catdic /usr/sbin/cannakill

	dodir /usr/share/man/man8 /usr/share/man/ja/man8
	for man in cannaserver cannakill ; do
		for mandir in "${D}"/usr/share/man "${D}"/usr/share/man/ja ; do
			mv ${mandir}/man1/${man}.1 ${mandir}/man8/${man}.8
		done
	done

	dodoc CHANGES.jp ChangeLog INSTALL* README* WHATIS*

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins doc/man/guide/tex/canna.{dvi,ps,pdf}
	fi

	newinitd "${FILESDIR}"/${P}.initd canna || die
	newconfd "${FILESDIR}"/${P}.confd canna || die
	insinto /etc/ ; newins "${FILESDIR}"/canna.hosts hosts.canna || die
	keepdir /var/log/canna/ || die

	# for backward compatibility
	dosbin "${FILESDIR}"/update-canna-dics_dir

	insinto /var/lib/canna/dic/dics.d/
	newins "${D}"/var/lib/canna/dic/canna/dics.dir 00canna.dics.dir

	# fix permission for user dictionary
	keepdir /var/lib/canna/dic/{user,group}
	fowners root:bin /var/lib/canna/dic/{user,group}
	fperms 775 /var/lib/canna/dic/{user,group}
}

pkg_postinst() {
	update-cannadic-dir
	elog
	elog "Canna dictionary format has been changed."
	elog "You should rebuild app-dict/canna-* after emerge."
	elog

	local localearchive="${ROOT}usr/$(get_libdir)/locale/locale-archive"
	if [ -f "${localearchive}" -a -x /usr/bin/localedef ] && \
		! /usr/bin/localedef --list-archive "${localearchive}" | grep -i 'ja_JP.eucjp' >/dev/null 2>&1 ; then
		elog "Some dictionary tools in this package require ja_JP.eucJP locale."
		elog "Please add ja_JP.eucJP locale to /etc/locale.gen:"
		elog
		elog "# echo 'ja_JP.EUC-JP EUC-JP' >> /etc/locale.gen"
		elog "# locale-gen"
		elog
	fi
}

pkg_prerm() {
	if [ -S /tmp/.iroha_unix/IROHA ] ; then
		# make sure cannaserver get stopped because otherwise
		# we cannot stop it with /etc/init.d after emerge -C canna
		einfo
		einfo "Stopping Canna for safe unmerge"
		einfo
		/etc/init.d/canna stop
		touch "${T}"/canna.cookie
	fi
}

pkg_postrm() {
	if [ -f /usr/sbin/cannaserver -a -e "${T}"/canna.cookie ] ; then
		#update-cannadic-dir
		einfo
		einfo "Restarting Canna"
		einfo
		/etc/init.d/canna start
		rm -f "${T}"/canna.cookie
	fi
}
