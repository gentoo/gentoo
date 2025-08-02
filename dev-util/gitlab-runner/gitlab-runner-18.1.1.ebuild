# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit eapi9-ver go-module systemd tmpfiles

# make sure this gets updated for every bump
GIT_COMMIT=2b813ade

DESCRIPTION="The official GitLab Runner, written in Go"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
SRC_URI="https://gitlab.com/gitlab-org/gitlab-runner/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv"

COMMON_DEPEND="
	acct-group/gitlab-runner
	acct-user/gitlab-runner
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-go/gox
	>=dev-lang/go-1.24.4
"

src_compile() {
	emake \
		BUILT="$(date -u '+%Y-%m-%dT%H:%M:%S%:z')" \
		GOX="${EPREFIX}/usr/bin/gox" \
		REVISION=${GIT_COMMIT} \
		VERSION=${PV} \
		runner-and-helper-bin-host
}

src_test() {
	CI=0 ego test
}

src_install() {
	newbin out/binaries/gitlab-runner-linux-* gitlab-runner
	newbin out/binaries/gitlab-runner-helper/gitlab-runner-helper.linux-* gitlab-runner-helper
	DOCS=( docs CHANGELOG.md README.md )
	einstalldocs
	insinto /usr/share/${PN}
	doins config.toml.example

	newconfd "${FILESDIR}/${PN}-18.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}-18.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
	keepdir /etc/${PN}
	fperms 0700 /etc/${PN}
	fowners gitlab-runner:gitlab-runner /etc/${PN}
}

pkg_postinst() {
	tmpfiles_process gitlab-runner.conf
	if ver_replacing -lt 18.0.0; then
		ewarn "The logs are now redirected to syslog instead of being stored in /var/log/gitlab-runner"
		ewarn
	fi
	[[ -f ${EROOT}/etc/gitlab-runner/config.toml ]] && return
	elog
	elog "To use the runner, you need to register it with this command:"
	elog "# gitlab-runner register"
	elog "This will also create the configuration file in /etc/gitlab-runner/config.toml"
}
