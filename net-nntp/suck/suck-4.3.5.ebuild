# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Grab news from a remote NNTP server and feed them to another"
HOMEPAGE="https://lazarus-pkgs.github.io/lazarus-pkgs/suck.html"
SRC_URI="https://github.com/lazarus-pkgs/suck/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="perl ssl"

RDEPEND="
	sys-libs/gdbm:=
	ssl? (
		dev-libs/openssl:0=
	)
"
DEPEND="${RDEPEND}
	sys-libs/db
	perl? ( dev-lang/perl )
"

src_prepare() {
	default

	rm java/*.class || die

	# Fix paths to the locations in Gentoo
	sed -i \
		-e 's:/usr/bin/rnews:/usr/$(get_libdir)/news/bin/rnews:' \
		-e 's:/var/lib/news/history:/var/spool/news/db/history:' \
		suck_config.h || die "path adaption sed failed"

	eautoreconf
}

src_configure() {
	if use ssl; then
		sed -i -e 's/^SSL_/#SSL_/' Makefile.in || die "ssl sed failed"
	fi

	if use perl; then
		sed -i -e 's/^PERL_/#PERL_/' Makefile.in || die "perl sed failed"
	fi

	econf --without-inn-lib --without-inn-include
}

src_compile() {
	emake phrases.h
	emake all lpost
}

src_install() {
	dobin lmove lpost rpost suck testhost
	doman man/*
	dodoc CHANGELOG CONTENTS README*
	docinto java
	dodoc java/*
	docinto perl
	dodoc perl/*
	docinto sample
	dodoc sample/*
}
