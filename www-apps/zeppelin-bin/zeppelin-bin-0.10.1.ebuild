# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN="zeppelin"
MY_P="${MY_PN}-${PV}-bin-all"

DESCRIPTION="Web-based interactive data analytics notebook launcher"
HOMEPAGE="https://zeppelin.apache.org"
SRC_URI="mirror://apache/zeppelin/${MY_PN}-${PV}/${MY_P}.tgz -> ${P}.tgz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	acct-group/zeppelin
	acct-user/zeppelin
	>=virtual/jdk-1.8"

RDEPEND="
	>=virtual/jre-1.8"

S="${WORKDIR}/${MY_P}"

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
