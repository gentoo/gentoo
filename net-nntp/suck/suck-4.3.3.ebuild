# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Grab news from a remote NNTP server and feed them to another"
HOMEPAGE="https://lazarus-pkgs.github.io/lazarus-pkgs/suck.html"
SRC_URI="https://github.com/lazarus-pkgs/suck/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="perl ssl"

COMMON_DEPEND="sys-libs/gdbm:=
	ssl? ( dev-libs/openssl:0= )"

DEPEND="${COMMON_DEPEND}
	sys-libs/db
	perl? ( dev-lang/perl )"

RDEPEND="${COMMON_DEPEND}
	net-nntp/inn"

PATCHES=( "${FILESDIR}/${PV}-fputs.patch" )

src_prepare() {
	default

	# Fix paths to the locations in Gentoo
	sed -i \
		-e 's:/usr/bin/rnews:/usr/$(get_libdir)/news/bin/rnews:' \
		-e 's:/var/lib/news/history:/var/spool/news/db/history:' \
		suck_config.h || die "path adaption sed failed"

	eautoreconf
}

src_configure() {
	use ssl || sed -i -e 's/^SSL_/#SSL_/' Makefile.in || die "ssl sed failed"
	use perl || sed -i -e 's/^PERL_/#PERL_/' Makefile.in || die "perl sed failed"

	econf
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
