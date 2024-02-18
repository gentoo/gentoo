# Copyright 2016-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module tmpfiles systemd flag-o-matic user-info

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.com https://github.com/go-gitea/gitea"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/go-gitea/gitea.git"
else
	SRC_URI="https://github.com/go-gitea/gitea/releases/download/v${PV}/gitea-src-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

S="${WORKDIR}/${PN}-src-${PV}"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
IUSE="+acct pam sqlite pie"

DEPEND="
	acct? (
		acct-group/git
		acct-user/git[gitea] )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	dev-vcs/git"
BDEPEND=">=dev-lang/go-1.21:="

DOCS=(
	custom/conf/app.example.ini CHANGELOG.md CONTRIBUTING.md README.md
)
FILECAPS=(
	-m 711 cap_net_bind_service+ep usr/bin/gitea
)

RESTRICT="test"

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
	gitea_tags+="$(usex pam ',pam' '')"
	gitea_tags+="$(usex sqlite ',sqlite,sqlite_unlock_notify' '')"

	gitea_settings=(
		"-X code.gitea.io/gitea/modules/setting.CustomConf=${EPREFIX}/etc/gitea/app.ini"
		"-X code.gitea.io/gitea/modules/setting.CustomPath=${EPREFIX}/var/lib/gitea/custom"
		"-X code.gitea.io/gitea/modules/setting.AppWorkPath=${EPREFIX}/var/lib/gitea"
	)

	makeenv=(
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[*]}"
		TAGS="${gitea_tags}"
	)

	if [[ ${PV} != *9999 ]]; then
		# Use variable STORED_VERSION_FILE (the "${S}/VERSION" file) to set version,
		# and prevent executing git command when it's not a live version.
		makeenv+=( GITHUB_REF_NAME="" )
	fi

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

	if [[ -n ${REPLACING_VERSIONS} ]] && ver_test "${REPLACING_VERSIONS}" -lt 1.21; then
		ewarn "Since 1.21.0:"
		ewarn "  1. The built-in SSH server will now only accept SSH user"
		ewarn "     certificates, not server certificates. This behaviour matches OpenSSH."
		ewarn "  2. The options of the subcommand must follow the subcommand now."
		ewarn "  3. Remove 'CHARSET' config option for MySQL, always use 'utf8mb4'."
		ewarn "For other breaking changes, see <https://github.com/go-gitea/gitea/releases/tag/v1.21.0>."
	fi
}
