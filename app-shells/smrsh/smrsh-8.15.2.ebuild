# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Sendmail restricted shell, for use with MTAs other than Sendmail"
HOMEPAGE="https://www.proofpoint.com/us/products/email-protection/open-source-email-solution"
SRC_URI="https://ftp.sendmail.org/sendmail.${PV}.tar.gz"
S="${WORKDIR}/sendmail-${PV}"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!mail-mta/sendmail"
DEPEND="${RDEPEND}
	sys-devel/m4"

src_prepare() {
	cd "${S}/${PN}" || die

	default

	sed -e "s:/usr/libexec:/usr/sbin:g" \
		-e "s:/usr/adm/sm.bin:/var/lib/smrsh:g" \
		-i README -i smrsh.8 || die "sed failed"

	sed -e "s|@@confCCOPTS@@|${CFLAGS}|" \
		-e "s|@@confLDOPTS@@|${LDFLAGS}|" \
		-e "s:@@confCC@@:$(tc-getCC):" "${FILESDIR}/site.config.m4" \
		> "${S}/devtools/Site/site.config.m4" || die "sed failed"
}

src_compile() {
	cd "${S}/${PN}" || die
	/bin/sh Build || die
}

src_install() {
	dosbin "${S}/obj.$(uname -s).$(uname -r).$(arch)/${PN}/${PN}"

	cd "${S}/${PN}" || die
	doman "${PN}.8"
	dodoc README

	keepdir /var/lib/${PN}
}

pkg_postinst() {
	elog "smrsh is compiled to look for programs in /var/lib/smrsh."
}
