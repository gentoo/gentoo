# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: please bump this together with mail-mta/sendmail and mail-filter/libmilter

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/sendmail.asc"
inherit toolchain-funcs verify-sig

DESCRIPTION="Sendmail restricted shell, for use with MTAs other than Sendmail"
HOMEPAGE="https://www.proofpoint.com/us/products/email-protection/open-source-email-solution"
if [[ -n $(ver_cut 4) ]] ; then
	# Snapshots have an extra version component (e.g. 8.17.1 vs 8.17.1.9)
	SRC_URI="
		https://ftp.sendmail.org/snapshots/sendmail.${PV}.tar.gz
		verify-sig? ( https://ftp.sendmail.org/snapshots/sendmail.${PV}.tar.gz.sig )
	"
fi
SRC_URI+="
	https://ftp.sendmail.org/sendmail.${PV}.tar.gz
	verify-sig? ( https://ftp.sendmail.org/sendmail.${PV}.tar.gz.sig )
"
SRC_URI+="
	https://ftp.sendmail.org/past-releases/sendmail.${PV}.tar.gz
	verify-sig? ( https://ftp.sendmail.org/past-releases/sendmail.${PV}.tar.gz.sig )
"
S="${WORKDIR}/sendmail-${PV}"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="!mail-mta/sendmail"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/m4
	verify-sig? ( ~sec-keys/openpgp-keys-sendmail-20250220 )
"

src_prepare() {
	default
	local confENVDEF="-DXDEBUG=0"

	if use elibc_musl; then
		eapply "${FILESDIR}"/${PN}-musl-disable-cdefs.patch
		confENVDEF+=" -DHASSTRERROR"
	fi

	cd "${S}/${PN}" || die

	sed -e "s:/usr/libexec:/usr/sbin:g" \
		-e "s:/usr/adm/sm.bin:/var/lib/smrsh:g" \
		-i README -i smrsh.8 || die "sed failed"

	sed -e "s|@@confCCOPTS@@|${CFLAGS}|" \
		-e "s|@@confLDOPTS@@|${LDFLAGS}|" \
		-e "s|@@confENVDEF@@|${confENVDEF}|" \
		-e "s:@@confCC@@:$(tc-getCC):" "${FILESDIR}/site.config.m4" \
		> "${S}/devtools/Site/site.config.m4" || die "sed failed"
}

src_compile() {
	cd "${S}/${PN}" || die
	/bin/sh Build AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" || die
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
