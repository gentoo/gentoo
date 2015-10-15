# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Sendmail restricted shell, for use with MTAs other than Sendmail"
HOMEPAGE="http://www.sendmail.org/"
SRC_URI="ftp://ftp.fu-berlin.de/unix/mail/sendmail/sendmail.${PV}.tar.gz"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!mail-mta/sendmail"
DEPEND="${RDEPEND}
	sys-devel/m4
	>=sys-apps/sed-4"

S="${WORKDIR}/sendmail-${PV}"

src_prepare() {
	cd "${S}/${PN}"
	sed -e "s:/usr/libexec:/usr/sbin:g" \
		-e "s:/usr/adm/sm.bin:/var/lib/smrsh:g" \
		-i README -i smrsh.8 || die "sed failed"

	sed -e "s:@@confCCOPTS@@:${CFLAGS}:" \
		-e "s:@@confLDOPTS@@:${LDFLAGS}:" \
		-e "s:@@confCC@@:$(tc-getCC):" "${FILESDIR}/site.config.m4" \
		> "${S}/devtools/Site/site.config.m4" || die "sed failed"
}

src_compile() {
	cd "${S}/${PN}"
	/bin/sh Build
}

src_install() {
	dosbin "${S}/obj.$(uname -s).$(uname -r).$(arch)/${PN}/${PN}" || die

	cd "${S}/${PN}"
	doman "${PN}.8" || die
	dodoc README || die

	keepdir "/var/lib/${PN}"
}

pkg_postinst() {
	elog "smrsh is compiled to look for programs in /var/lib/smrsh."
	echo
}
