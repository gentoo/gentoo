# Copyright 2016-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module tmpfiles systemd flag-o-matic user-info

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.com https://github.com/go-gitea/gitea"

SRC_URI="https://github.com/go-gitea/gitea/releases/download/v${PV}/gitea-src-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-src-${PV}"
LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="+acct gogit pam pie"

DEPEND="
	acct? (
		acct-group/git
		acct-user/git[gitea] )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	!gogit? ( dev-vcs/git )"
BDEPEND=">=dev-lang/go-1.27.0:="

DOCS=(
	custom/conf/app.example.ini CONTRIBUTING.md README.md
)
FILECAPS=(
	-m 711 cap_net_bind_service+ep usr/bin/gitea
)

RESTRICT="test"
QA_PRESTRIPPED="/usr/bin/${PN}"

src_prepare() {
	default

	sed -i -e "s#^MODE = console#MODE = file#" custom/conf/app.example.ini || die
}

src_configure() {
	# bug 832756 - PIE build issues
	filter-flags -fPIE
	filter-ldflags -fPIE -pie
}

src_compile() {
	local gitea_tags
	local -a gitea_settings makeenv

	# The space-separated list of the -tags flag is deprecated, please
	# always use the comma-separated list in the future.
	gitea_tags="bindata"
	gitea_tags+="$(usex gogit ' gogit' '')"
	gitea_tags+="$(usex pam ' pam' '')"

	gitea_settings=(
		"-X gitea.dev/modules/setting.CustomConf=${EPREFIX}/etc/gitea/app.ini"
		"-X gitea.dev/modules/setting.CustomPath=${EPREFIX}/var/lib/gitea/custom"
		"-X gitea.dev/modules/setting.AppWorkPath=${EPREFIX}/var/lib/gitea"
	)

	makeenv=(
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[*]}"
		TAGS="${gitea_tags}"
	)

	if use pie ; then
		# Please check the supported platforms when a new keyword request opened,
		# refer to file: 'go/src/internal/platform/supported.go'.
		# When PIE buildmode is not supported by internal linker, the external
		# linker will be used automatically, refer to:
		# https://github.com/golang/go/blob/ed817f1c4055a559a94afffecbb91c78e4f39942/src/cmd/link/internal/ld/config.go#L149
		makeenv+=( EXTRA_GOFLAGS="-buildmode=pie" )
	fi

	env "${makeenv[@]}" emake backend
}

src_install() {
	dobin gitea

	einstalldocs

	newconfd "${FILESDIR}/gitea.confd-r1" gitea
	newinitd "${FILESDIR}/gitea.initd-r3" gitea
	newtmpfiles - gitea.conf <<-EOF
		d /run/gitea 0755 git git
	EOF
	systemd_newunit "${FILESDIR}"/gitea.service-r4 gitea.service

	insinto /etc/gitea
	newins custom/conf/app.example.ini app.ini
	if use acct; then
		fowners root:git /etc/gitea/{,app.ini}
		fperms g+w,o-rwx /etc/gitea/{,app.ini}

		diropts -m0750 -o git -g git
		keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
		keepdir /var/log/gitea
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst

	# It is not guaranteed that the git user and group always exist (due to the acct USE Flag),
	# but for convenience, the tmpfile uses the git user and group by default.
	# To avoid installation errors, a condition needs to be added here:
	#   if there is no git user or group, the installation of tmpfile will be skipped
	#   and the user will be notified to handle it by themselves.
	if egetent passwd git &>/dev/null && \
		egetent group git &>/dev/null; then
		tmpfiles_process gitea.conf
	else
		eerror "Unable to install the tmpfile for gitea due to the git user or group is missing,"
		eerror "please install tmpfile manually or rebuild this package with USE flag 'acct'."
		eerror "You can simply copy the default tmpfile from '/usr/lib/tmpfiles.d/gitea.conf'"
		eerror "to higher priority path '/etc/tmpfiles.d/gitea.conf', and correct it with"
		eerror "the right User and Group value (see tmpfiles.d(5) for details), then execute:"
		eerror "  # systemd-tmpfiles --create /etc/tmpfiles.d/gitea.conf"
		eerror "to install it."
	fi

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ver_test "${REPLACING_VERSIONS}" -lt 28; then
			ewarn "Since version 28.0.0 (the release following 1.27.x):"
			ewarn "  1. Egress controls (git, webhooks, migrations) are reworked around"
			ewarn "     '[security] EGRESS_MODE' (default 'lax'): ALLOWED_HOST_LIST then"
			ewarn "     only restricts private/loopback/CGNAT hosts, public hosts are"
			ewarn "     always allowed. Set EGRESS_MODE = strict for an exclusive list."
			ewarn "  2. The 'external' and '*' entries and wildcard IPs are rejected;"
			ewarn "     'example.com' now also matches subdomains, '*.example.com' does"
			ewarn "     not match the apex. Invalid block list entries are fatal."
			ewarn "  3. '[migrations]' ALLOWED_DOMAINS/BLOCKED_DOMAINS/ALLOW_LOCALNETWORKS"
			ewarn "     are deprecated."
			ewarn "  4. Proxy URLs must use 'socks5://', 'socks://' is no longer accepted."
			ewarn "  5. Completed action runs are now deleted after '[actions]"
			ewarn "     RUN_RETENTION_DAYS' (default: 400, 0 keeps them forever)."
			ewarn "For other breaking changes, see <https://github.com/go-gitea/gitea/releases/tag/v28.0.0>."
		fi
	fi
}
