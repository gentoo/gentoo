# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/mcabber/mcabber-0.10.2_p20131025.ebuild,v 1.3 2014/06/14 09:35:29 phajdan.jr Exp $

EAPI=5

inherit flag-o-matic autotools

DESCRIPTION="A small Jabber console client with various features, like MUC, SSL, PGP"
HOMEPAGE="http://mcabber.com/"
REV="a18e1b488f1c"
SRC_URI="http://mcabber.com/hg/index.cgi/archive/${REV}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/${PN}-${REV}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="aspell crypt idn modules otr spell ssl vim-syntax"

LANGS="cs de fr it nl pl ru uk"
# localized help versions are installed only, when LINGUAS var is set
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done;

RDEPEND="crypt? ( >=app-crypt/gpgme-1.0.0 )
	otr? ( >=net-libs/libotr-3.1.0 )
	aspell? ( app-text/aspell )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	idn? ( net-dns/libidn  )
	spell? ( app-text/enchant )
	dev-libs/glib:2
	sys-libs/ncurses
	>=net-libs/loudmouth-1.4.3-r1[ssl?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use aspell && use spell; then
		ewarn "NOTE: You have both USE flags 'aspell' and 'spell' enabled, enchant (USE flag 'spell') will be preferred."
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable crypt gpgme) \
		$(use_enable otr) \
		$(use_enable aspell) \
		$(use_enable spell enchant) \
		$(use_enable modules) \
		$(use_with idn libidn)
}

src_install() {
	emake DESTDIR="${D}" install

	# clean unneeded language documentation
	for i in ${LANGS}; do
		use linguas_${i} || rm -rf "${ED}"/usr/share/${PN}/help/${i}
	done

	dodoc AUTHORS ChangeLog NEWS README TODO mcabberrc.example
	dodoc doc/README_PGP.txt

	# contrib themes
	insinto /usr/share/${PN}/themes
	doins "${S}"/contrib/themes/*

	# contrib generic scripts
	exeinto /usr/share/${PN}/scripts
	doexe "${S}"/contrib/*.{pl,py}

	# contrib event scripts
	exeinto /usr/share/${PN}/scripts/events
	doexe "${S}"/contrib/events/*

	if use vim-syntax; then
		cd contrib/vim/ || die

		insinto /usr/share/vim/vimfiles/syntax
		doins mcabber_log-syntax.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins mcabber_log-ftdetect.vim
	fi
}

pkg_postinst() {
	elog
	elog "MCabber requires you to create a subdirectory .mcabber in your home"
	elog "directory and to place a configuration file there."
	elog "An example mcabberrc was installed as part of the documentation."
	elog "To create a new mcabberrc based on the example mcabberrc, execute the"
	elog "following commands:"
	elog
	elog "  mkdir -p ~/.mcabber"
	elog "  bzcat ${EROOT}usr/share/doc/${PF}/mcabberrc.example.bz2 >~/.mcabber/mcabberrc"
	elog
	elog "Then edit ~/.mcabber/mcabberrc with your favorite editor."
	elog
	elog "See the CONFIGURATION FILE and FILES sections of the mcabber"
	elog "manual page (section 1) for more information."
	elog
	elog "From version 0.9.0 on, MCabber supports PGP encryption of messages."
	elog "See README_PGP.txt for details."
	echo
	einfo "Check out ${EROOT}usr/share/${PN} for contributed themes and event scripts."
	echo
}
