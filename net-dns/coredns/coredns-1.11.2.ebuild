# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module multiprocessing systemd tmpfiles toolchain-funcs

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://github.com/coredns/coredns"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coredns/coredns.git"
else
	#SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	# The v1.11.2 tag went missing upstream, so use a previously fetched copy.
	SRC_URI="https://dev.gentoo.org/~zmedico/dist/${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"
	KEYWORDS="amd64"
fi

# main
LICENSE="Apache-2.0"
# deps
LICENSE+=" MIT BSD ISC MPL-2.0 BSD-2"

SLOT="0"
IUSE="test"
# TODO: debug test failure with deps tarball
RESTRICT="test"

RDEPEND="acct-user/coredns
	acct-group/coredns"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/${PN}
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_prepare() {
	default
	use test || sed -i -e 's|coredns: $(CHECKS)|coredns:|' Makefile
}

src_compile() {
	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export GITCOMMIT=''

	# Mimicking go-module.eclass's GOFLAGS
	if use amd64 || use arm || use arm64 ||
			( use ppc64 && [[ $(tc-endian) == "little" ]] ) || use s390 || use x86; then
		local buildmode="-buildmode=pie"
	fi
	export BUILDOPTS="-buildvcs=false -modcacherw -v -x -p=$(makeopts_jobs) ${buildmode}"

	default
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
