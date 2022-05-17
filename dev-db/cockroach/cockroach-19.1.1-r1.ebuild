# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV=v${PV}
CHECKREQS_MEMORY="2G"

inherit check-reqs toolchain-funcs

DESCRIPTION="open source database for building cloud services"
HOMEPAGE="https://www.cockroachlabs.com"
SRC_URI="https://binaries.cockroachdb.com/cockroach-${MY_PV}.src.tgz"
S="${WORKDIR}/cockroach-${MY_PV}"

LICENSE="Cockroach Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/cockroach
	acct-user/cockroach
"

DEPEND="
	${RDEPEND}
	>=app-arch/xz-utils-5.2.3
	>=dev-lang/go-1.8.3
	>=dev-util/cmake-3.8.1
"

QA_EXECSTACK="usr/bin/cockroach"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_compile() {
	# workaround for https://github.com/cockroachdb/cockroach/issues/20596
	unset CMAKE_MODULE_PATH
	emake build
}

src_install() {
	dobin src/github.com/cockroachdb/cockroach/cockroach
	insinto /etc/security/limits.d
	newins "${FILESDIR}"/cockroach-limits.conf cockroach.conf
	newconfd "${FILESDIR}"/cockroach.confd-1.0 cockroach
	newinitd "${FILESDIR}"/cockroach.initd-1.0.1 cockroach
	keepdir /var/log/cockroach
	fowners cockroach:cockroach /var/log/cockroach
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "The default setup is for the first node of an insecure"
		ewarn "cluster that only listens on localhost."
		ewarn "Please read the cockroach manual at the following url"
		ewarn "and configure /etc/conf.d/cockroach correctly if you"
		ewarn "plan to use it in production."
		ewarn
		ewarn "http://cockroachlabs.com/docs"
	fi
}
