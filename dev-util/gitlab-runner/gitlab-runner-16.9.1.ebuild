# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd tmpfiles

# make sure this gets updated for every bump
GIT_COMMIT=782c6ecb

DESCRIPTION="The official GitLab Runner, written in Go"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
SRC_URI="https://gitlab.com/gitlab-org/gitlab-runner/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv"

COMMON_DEPEND="acct-group/gitlab-runner
	acct-user/gitlab-runner"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="dev-go/gox"

DOCS=( docs CHANGELOG.md README.md config.toml.example )

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	emake \
		BUILT="$(date -u '+%Y-%m-%dT%H:%M:%S%:z')" \
		GOX="${EPREFIX}/usr/bin/gox" \
		REVISION=${GIT_COMMIT} \
		VERSION=${PV} \
		runner-bin-host
}

src_test() {
	CI=0 ego test
}

src_install() {
	dobin out/binaries/gitlab-runner
	einstalldocs

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
	keepdir /{etc,var/log}/${PN}
	fperms 0700 /{etc,var/log}/gitlab-runner
	fowners gitlab-runner:gitlab-runner /{etc,var/log}/${PN}
}

pkg_postinst() {
	tmpfiles_process gitlab-runner.conf
	[[ -f ${EROOT}/etc/gitlab-runner/config.toml ]] && return
	elog
	elog "To use the runner, you need to register it with this command:"
	elog "# gitlab-runner register"
	elog "This will also create the configuration file in /etc/gitlab-runner/config.toml"
}
