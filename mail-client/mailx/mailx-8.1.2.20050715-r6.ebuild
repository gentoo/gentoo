# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils flag-o-matic toolchain-funcs

MX_MAJ_VER=${PV%.*}
MX_MIN_VER=${PV##*.}
MY_PV=${MX_MAJ_VER}-0.${MX_MIN_VER}cvs
S=${WORKDIR}/${PN}-${MY_PV}.orig/
debian_patch=${PN}_${MY_PV}-1.diff.gz

DESCRIPTION="The /bin/mail program, which is used to send mail via shell scripts"
HOMEPAGE="http://www.debian.org/"
SRC_URI="mirror://gentoo/mailx_${MY_PV}.orig.tar.gz
	mirror://gentoo/${debian_patch}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=">=net-libs/liblockfile-1.03
	virtual/mta
	mail-client/mailx-support"

RDEPEND="${DEPEND}
	!mail-client/nail
	!net-mail/mailutils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}/${debian_patch}"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	sed -i -e "s: -O2: \$(EXTRAFLAGS):g" Makefile
	epatch "${FILESDIR}/${P}-offsetof.patch"
}

src_compile() {
	emake CC=$(tc-getCC) EXTRAFLAGS="${CFLAGS}" || die
}

src_install() {
	dodir /usr/bin /bin /usr/share/man/man1 /etc

	insinto /usr/bin
	insopts -m 755
	doins mail || die

	doman mail.1

	dosym mail /usr/bin/Mail
	dosym mail /usr/bin/mailx
	dosym mail.1 /usr/share/man/man1/Mail.1

	insinto /usr/share/mailx/
	doins misc/mail.help misc/mail.tildehelp || die
	insinto /etc
	insopts -m 644
	doins misc/mail.rc || die

	# compatibility link
	dosym /usr/bin/mail /bin/mail || die
}

pkg_postinst() {
	elog "mail command now lives in /usr/bin."
	elog "Please adjust your scripts."
}
