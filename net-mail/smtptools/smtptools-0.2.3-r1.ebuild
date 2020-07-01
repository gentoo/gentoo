# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A collection of tools to send or receive mails with SMTP"
HOMEPAGE="https://www.ohse.de/uwe/software/smtptools.html"
SRC_URI="ftp://ftp.ohse.de/uwe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~x86"

RDEPEND="!net-mail/qtools"
PATCHES=(
	"${FILESDIR}"/${P}-cleanups.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	eapply "${FILESDIR}"/${P}-autotools.patch
	mv configure.{in,ac} || die
	rm acconfig.h || die

	default
	eautoreconf
}
