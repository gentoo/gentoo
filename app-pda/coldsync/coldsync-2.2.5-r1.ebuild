# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic perl-module toolchain-funcs

DESCRIPTION="A command-line tool to synchronize PalmOS PDAs with Unix workstations"
HOMEPAGE="http://www.coldsync.org/"
SRC_URI="http://www.coldsync.org/download/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="nls perl"

RDEPEND="perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-toolchain.patch

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_prepare
		popd
	fi
}

src_configure() {
	tc-export CC CXX
	append-cflags -fno-strict-aliasing

	# TODO: i18n: msgfmt fails but doesn't || die
	econf \
		$(use_with nls i18n) \
		--without-perl

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_configure
		popd
	fi
}

src_compile() {
	default

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_compile
		popd
	fi
}

src_install() {
	emake \
		PREFIX="${D}"/usr \
		MANDIR="${D}"/usr/share/man \
		SYSCONFDIR="${D}"/etc \
		DATADIR="${D}"/usr/share \
		INFODIR="${D}"/usr/share/info \
		INSTALLMAN3DIR="${D}"/usr/share/man/man3 \
		INSTALLSITEMAN3DIR="${D}"/usr/share/man/man3 \
		INSTALLVENDORMAN3DIR="${D}"/usr/share/man/man3 \
		install

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_install
		popd
	fi

	dodoc AUTHORS ChangeLog FAQ HACKING NEWS README* TODO
}
