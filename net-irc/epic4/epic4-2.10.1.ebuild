# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/epic4/epic4-2.10.1.ebuild,v 1.8 2015/03/21 13:40:29 jlec Exp $

EAPI=4

inherit autotools eutils flag-o-matic toolchain-funcs

HELP_V="20050315"

DESCRIPTION="Epic4 IRC Client"
HOMEPAGE="http://epicsol.org/"
SRC_URI="
	ftp://ftp.epicsol.org/pub/epic/EPIC4-PRODUCTION/${P}.tar.bz2
	ftp://prbh.org/pub/epic/EPIC4-PRODUCTION/epic4-help-${HELP_V}.tar.gz
	mirror://gentoo/epic4-local.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6 perl ssl"

DEPEND="
	>=sys-libs/ncurses-5.2
	perl? ( dev-lang/perl )
	ssl? ( >=dev-libs/openssl-0.9.5:0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/epic-defaultserver.patch \
		"${FILESDIR}"/${P}-make-recursion.patch \
		"${FILESDIR}"/${P}-perl.patch

	eautoconf

	rm -f "${WORKDIR}"/help/Makefile || die
	ecvs_clean
}

src_configure() {
	replace-flags "-O?" "-O"

	# copied from alt overlay
	[[ ${CHOST} == *-interix* ]] && export ac_cv_func_getpgrp_void=yes

	econf \
		--libexecdir="${EPREFIX}"/usr/libexec/${PN} \
		$(use_with ipv6) \
		$(use_with perl) \
		$(use_with ssl)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	einstall \
		sharedir="${ED}"/usr/share \
		libexecdir="${ED}"/usr/libexec/${PN}

	dodoc BUG_FORM README KNOWNBUGS VOTES

	cd "${S}"/doc || die
	docinto doc
	dodoc \
		*.txt colors EPIC* IRCII_VERSIONS local_vars missing new-load \
		nicknames outputhelp SILLINESS TS4

	insinto /usr/share/epic
	doins -r "${WORKDIR}"/help
}

pkg_postinst() {
	if [ ! -f "${EROOT}"/usr/share/epic/script/local ]; then
		elog "/usr/share/epic/script/local does not exist, I will now"
		elog "create it. If you do not like the look/feel of this file, or"
		elog "if you'd prefer to use your own script, simply remove this"
		elog "file.  If you want to prevent this file from being installed"
		elog "in the future, simply create an empty file with this name."
		cp "${WORKDIR}"/epic4-local "${EROOT}"/usr/share/epic/script/local
		elog
		elog "This provided local startup script adds a number of nifty"
		elog "features to Epic including tab completion, a comprehensive set"
		elog "of aliases, and channel-by-channel logging.  To prevent"
		elog "unintentional conflicts with your own scripting, if either the"
		elog "~/.ircrc or ~/.epicrc script files exist, then the local script"
		elog "is *not* run.  If you like the script but want to make careful"
		elog "additions (such as selecting your usual servers or setting your"
		elog "nickname), simply copy /usr/share/epic/script/local to ~/.ircrc"
		elog "and then add your additions to the copy."
	fi

	# Fix for bug 59075
	chmod 755 "${EROOT}"/usr/share/epic/help
}
