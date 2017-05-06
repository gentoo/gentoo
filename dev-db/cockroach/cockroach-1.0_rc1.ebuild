# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PV=v1.0-rc.1
CHECKREQS_MEMORY="2G"

inherit check-reqs toolchain-funcs user

DESCRIPTION="open source database for building cloud services"
HOMEPAGE="https://www.cockroachlabs.com"
SRC_URI="https://binaries.cockroachdb.com/cockroach-${MY_PV}.src.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.8.1"

S="${WORKDIR}/cockroach-${MY_PV}"

pkg_pretend() {
	check-reqs_pkg_pretend
	if [[ ${MERGE_TYPE} != binary && $(gcc-major-version) -lt 6 ]]; then
		eerror "Cockroach cannot be built with this version of gcc."
		eerror "You need at least gcc-6.0"
		die "Your C compiler is too old for this package."
	fi
}

pkg_setup() {
	check-reqs_pkg_setup
	enewgroup cockroach
	enewuser cockroach -1 /bin/sh /var/lib/cockroach cockroach
}

src_compile() {
	emake GOPATH="${S}" build || die
}

src_install() {
	emake GOPATH="${S}" install || die
dobin bin/*
insinto /etc/security/limits.d
newins "${FILESDIR}"/cockroach-limits.conf cockroach.conf
newinitd "${FILESDIR}"/cockroach.initd cockroach
dodir /var/log/cockroach
fowners cockroach:cockroach /var/log/cockroach
if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "The default setup is for the first node of an insecure"
		ewarn "cluster that only listens on localhost."
		ewarn "Please read the cockroach manual at the following url"
		ewarn "and configure /etc/conf.d/cockroach correctly if you"
		ewarn "plan to use it in production."
		elog
		elog "http://cockroachlabs.com/docs"
	fi
}
