# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Don't forget to update when bumping. Used in --version output
EGIT_COMMIT="596a9f9e67dd9b01e15bc04a999460422fe65166"

inherit fcaps go-module systemd tmpfiles

ARCHIVE_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

LICENSE="Apache-2.0 MIT BSD ISC MPL-2.0 BSD-2"
SLOT="0"
RDEPEND="acct-user/coredns
	acct-group/coredns"

# TODO: debug test failure with deps tarball
RESTRICT+=" test"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/${PN}
)

src_compile() {
	go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${EGIT_COMMIT}" ||
		die "go build failed"
}

src_install() {
	dobin "${PN}"
	einstalldocs
	doman man/*

	newinitd "${FILESDIR}"/coredns.initd coredns
	newconfd "${FILESDIR}"/coredns.confd coredns

	insinto /etc/coredns/
	newins "${FILESDIR}"/Corefile.example Corefile

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/coredns.logrotated coredns

	systemd_dounit "${FILESDIR}"/coredns.service
	newtmpfiles "${FILESDIR}"/coredns.tmpfiles "${PN}.conf"
}

src_test() {
	# eclass default '-x' makes tests output unreadable
	export GOFLAGS="-v -mod=readonly"

	local known_fail=(
		"TestZoneExternalCNAMELookupWithProxy"
		"TestMetricsSeveralBlocs"
		"TestMetricsAvailable"
		"TestMetricsAvailableAfterReload"
		"TestMetricsAvailableAfterReloadAndFailedReload"
	)
	# concat as '|^Test1$|^Test2$|^Test3...$':
	local known_fail_re="$(printf '|^%s$' "${known_fail[@]}")"
	# drop '|' in the begining:
	known_fail_re="${known_fail_re:1}"

	local working_tests_re="$(
		# get list of all test:
		{ GOFLAGS="-mod=readonly" go test -list . ./... ||
			die "Can't get list of tests"; } |
		# skip "no tests" messages as well as know failures:
		grep -v -E " |${known_fail_re}" |
		# format a regexp:
		sed -z 's/\n/$|^/g'
	)"
	# drop '|^' in the end:
	working_tests_re="^${working_tests_re::-2}"

	go test -race -run "${working_tests_re}" ./... || die "Tests failed"
	go test -race -run "${known_fail_re}" ./... || ewarn "Known test failure"
}

pkg_postinst() {
	fcaps_pkg_postinst
	tmpfiles_process ${PN}.conf
}
