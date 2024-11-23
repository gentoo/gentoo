# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 verify-sig

MY_PN="zeppelin"
MY_P="${MY_PN}-${PV}-bin-all"

DESCRIPTION="Web-based interactive data analytics notebook launcher"
HOMEPAGE="https://zeppelin.apache.org"
SRC_URI="mirror://apache/zeppelin/${MY_PN}-${PV}/${MY_P}.tgz -> ${P}.tgz
	verify-sig? ( https://downloads.apache.org/zeppelin/zeppelin-${PV}/${MY_P}.tgz.asc -> ${P}.tgz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 MIT OFL-1.1 WTFPL-2 BSD BSD-2 CC0-1.0 CDDL EPL-1.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/zeppelin.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-zeppelin )"
DEPEND="
	acct-group/zeppelin
	acct-user/zeppelin
	>=virtual/jdk-1.8
"

RDEPEND="
	acct-group/zeppelin
	acct-user/zeppelin
	>=virtual/jre-1.8
"

QA_PREBUILT="*"

INSTALL_DIR="/opt/${P}"

src_prepare() {
	default
	local SO_TO_DELETE=(
		interpreter/sh/libpty/freebsd/x86/libpty.so
		interpreter/sh/libpty/freebsd/x86_64/libpty.so
		interpreter/sh/libpty/linux/ppc64le/libpty.so
	)

	for s in "${SO_TO_DELETE[@]}"; do
		rm -v ${s} || die
	done
	rm -r licenses || die
}

src_install() {
	keepdir /var/log/zeppelin
	fowners -R zeppelin:zeppelin /var/log/zeppelin

	newinitd "${FILESDIR}/zeppelin.init.d" zeppelin

	dodir "${INSTALL_DIR}"
	cp -pRP * "${ED}/${INSTALL_DIR}" || die
	dosym "${P}" /opt/zeppelin
	fowners -R zeppelin:zeppelin "${INSTALL_DIR}"
}
