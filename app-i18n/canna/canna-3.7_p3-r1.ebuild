# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cannadic eutils multilib

MY_P="Canna${PV//./}"
MY_P="${MY_P/_/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/canna/9565/${MY_P}.tar.bz2"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4
	x11-misc/gccmakedep
	x11-misc/imake"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-gentoo.patch \
		"${FILESDIR}"/${PN}-kpdef.patch \
		"${FILESDIR}"/${PN}-posix-sort.patch

	find . -name '*.man' -o -name '*.jmn' | xargs sed -i.bak -e 's/1M/8/g' || die

	# Multilib-strict fix for amd64
	sed -i -e "s:\(DefLibCannaDir.*\)/lib:\1/$(get_libdir):g" Canna.conf* || die
}

src_compile() {
	xmkmf || die

	#make libCannaDir=../lib/canna canna || die
	# bug #279706
	emake -j1 CDEBUGFLAGS="${CFLAGS}" canna || die

	#if use doc ; then
	#	einfo "Compiling DVI, PS (and PDF) document"
	#	cd doc/man/guide/tex
	#	xmkmf || die
	#	emake -j1 JLATEXCMD=platex \
	#		DVI2PSCMD="dvips -f" \
	#		canna.dvi canna.ps || die
	#	if has_version 'app-text/dvipdfmx' && \
	#		( has_version 'app-text/acroread' \
	#		|| has_version 'app-text/xpdf-japanese' ); then
	#		emake -j1 JLATEXCMD=platex \
	#			DVI2PSCMD="dvips -f" \
	#			canna.pdf || die
	#	fi
	#fi
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

	#if use doc ; then
	#	insinto /usr/share/doc/${PF}
	#	doins doc/man/guide/tex/canna.{dvi,ps,pdf}
	#fi

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

	if ! locale -a | grep -iq "ja_JP.eucjp"; then
		elog "Some dictionary tools in this package require ja_JP.EUC-JP locale."
		elog
		elog "# echo 'ja_JP.EUC-JP EUC-JP' >> /etc/locale.gen"
		elog "# locale-gen"
		elog
	fi
}
