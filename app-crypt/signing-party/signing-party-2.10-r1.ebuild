# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs autotools

DESCRIPTION="A collection of several tools related to OpenPGP"
HOMEPAGE="https://salsa.debian.org/signing-party-team/signing-party"
SRC_URI="mirror://debian/pool/main/s/signing-party/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl
	app-crypt/libmd"
RDEPEND="${DEPEND}
	>=app-crypt/gnupg-1.3.92
	dev-perl/GnuPG-Interface
	dev-perl/Text-Template
	dev-perl/MIME-tools
	net-mail/qprint
	>=dev-perl/MailTools-1.62
	dev-perl/Net-IDN-Encode
	virtual/mailx
	virtual/mta
	|| (
		dev-perl/libintl-perl
		dev-perl/Text-Iconv
		app-text/recode
	)"

src_prepare() {
	default

	# app-crypt/keylookup
	rm -r keylookup || die
	sed -i -e 's#keylookup/keylookup##' Makefile || die

	# media-gfx/springgraph
	rm -r springgraph || die

	find . -name Makefile | xargs sed -i -e 's/CFLAGS:=/CFLAGS=/' -e 's/CPPFLAGS:=/CPPFLAGS=/' -e 's/LDFLAGS:=/LDFLAGS=/'

	sed -i -e 's/autoreconf/true/g' keyanalyze/Makefile || die
	pushd keyanalyze/pgpring || die
	eautoreconf
	popd || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		STRIP=true
}

src_install() {
	einstalldocs

	# Check Makefile when a new tool is introduced to this package.
	# caff
	dobin caff/caff caff/pgp-clean caff/pgp-fixkey
	docinto caff
	dodoc caff/{README*,THANKS,TODO,caffrc.sample}
	# gpgdir
	dobin gpgdir/gpgdir
	docinto gpgdir
	dodoc gpgdir/{VERSION,LICENSE,README,INSTALL,CREDITS,ChangeLog*}
	# gpg-key2ps
	dobin gpg-key2ps/gpg-key2ps
	docinto gpg-key2ps
	dodoc gpg-key2ps/README
	# gpglist
	dobin gpglist/gpglist
	# gpg-mailkeys
	dobin gpg-mailkeys/gpg-mailkeys
	docinto gpg-mailkeys
	dodoc gpg-mailkeys/{example.gpg-mailkeysrc,README}
	# gpgparticipants
	dobin gpgparticipants/gpgparticipants
	# gpgwrap
	dobin gpgwrap/bin/gpgwrap
	docinto gpgwrap
	dodoc gpgwrap/{LICENSE,NEWS,README}
	doman gpgwrap/doc/gpgwrap.1
	# gpgsigs
	dobin gpgsigs/gpgsigs
	insinto /usr/share/signing-party
	# keyanalyze
	# TODO: some of the scripts are intended for webpages, and not really
	# packaging, so they are NOT installed yet.
	newbin keyanalyze/pgpring/pgpring pgpring-keyanalyze
	dobin keyanalyze/{keyanalyze,process_keys}
	docinto keyanalyze
	dodoc keyanalyze/{README,Changelog}
	# See app-crypt/keylookup instead
	#dobin keylookup/keylookup
	#docinto keylookup
	#dodoc keylookup/NEWS
	# sig2dot
	dobin sig2dot/sig2dot
	dodoc sig2dot/README.sig2dot
	# gog-key2latex
	dobin gpg-key2latex/gpg-key2latex
	# See media-gfx/springgraph instead
	#dobin springgraph/springgraph
	#dodoc springgraph/README.springgraph
	# all other manpages, and the root doc
	doman */*.1
	dodoc README
}
