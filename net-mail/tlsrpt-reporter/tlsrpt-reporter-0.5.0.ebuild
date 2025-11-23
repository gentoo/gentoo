# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} python3_13t pypy3 pypy3_11 )

inherit distutils-r1 systemd tmpfiles

DESCRIPTION="tools and daemons to implement TLSRPT services"
HOMEPAGE="https://github.com/sys4/tlsrpt-reporter"
MY_P="${PN}-${PV/_/}"
SRC_URI="https://github.com/sys4/${PN}/archive/refs/tags/v${PV/_/}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${PV/_/}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man test"

RDEPEND="
	acct-group/tlsrpt-reporter
	acct-user/tlsrpt-reporter
	dev-db/sqlite
"
BDEPEND="man? ( dev-ruby/asciidoctor )"

distutils_enable_tests unittest

src_compile() {
	if use man; then
		pushd doc
		emake
		popd
	fi
	distutils-r1_src_compile
}

src_install() {
	use man && doman doc/*.1
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/tlsrpt-"{collectd,reportd}.service
	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}".conf
	insinto /etc/tlsrpt-reporter
	doins "${FILESDIR}/"*.cfg
}

pkg_postinst() {
	tmpfiles_process "${PN}".conf
}
