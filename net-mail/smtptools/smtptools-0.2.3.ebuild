# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils autotools

DESCRIPTION="A collection of tools to send or receive mails with SMTP"
HOMEPAGE="http://www.ohse.de/uwe/software/smtptools.html"
SRC_URI="ftp://ftp.ohse.de/uwe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 x86"
IUSE=""

RDEPEND="!net-mail/qtools"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	mv configure.{in,ac} || die
	rm acconfig.h || die
	epatch "${FILESDIR}"/${P}-cleanups.patch
	eautoreconf
}
