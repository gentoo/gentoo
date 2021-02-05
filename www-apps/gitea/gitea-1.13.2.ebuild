# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps go-module tmpfiles systemd
MY_PV="${PV/_rc/-rc}"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io"

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/go-gitea/gitea/releases/download/v${MY_PV}/gitea-src-${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64"
	S="${WORKDIR}"
else
	EGIT_REPO_URI="https://github.com/go-gitea/gitea"
	inherit git-r3
	S="${WORKDIR}/${P}"
fi

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
IUSE="+acct build-client pam sqlite"

BDEPEND="build-client? ( >=net-libs/nodejs-10[npm] )"
COMMON_DEPEND="
	acct? (
		acct-group/git
		acct-user/git[gitea] )
	pam? ( sys-libs/pam )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-vcs/git"

DOCS=(
	custom/conf/app.example.ini CONTRIBUTING.md README.md
)
FILECAPS=(
	cap_net_bind_service+ep usr/bin/gitea
)

RESTRICT="test"
QA_PRESTRIPPED="usr/bin/gitea"

src_prepare() {
	default

	local sedcmds=(
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/gitea/gitea-repositories#"
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/gitea/data#"
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"
		-e "s#^MODE = console#MODE = file#"
		-e "s#^LEVEL = Trace#LEVEL = Info#"
		-e "s#^LOG_SQL = true#LOG_SQL = false#"
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"
	)

	sed -i "${sedcmds[@]}" custom/conf/app.example.ini || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.example.ini || die
	fi

	einfo "Remove tests which are known to fail with network-sandbox enabled."
	rm ./modules/migrations/github_test.go || die

	einfo "Remove tests which depend on gitea git-repo."
	rm ./modules/git/blob_test.go || die
	rm ./modules/git/repo_test.go || die

	# Remove already build assets (like frontend part)
	use build-client && emake clean-all
}

src_compile() {
	local gitea_tags=(
		bindata
		$(usev pam)
		$(usex sqlite 'sqlite sqlite_unlock_notify' '')
	)
	local gitea_settings=(
		"-X code.gitea.io/gitea/modules/setting.CustomConf=${EPREFIX}/etc/gitea/app.ini"
		"-X code.gitea.io/gitea/modules/setting.CustomPath=${EPREFIX}/var/lib/gitea/custom"
		"-X code.gitea.io/gitea/modules/setting.AppWorkPath=${EPREFIX}/var/lib/gitea"
	)
	local makeenv=(
		TAGS="${gitea_tags[*]}"
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[*]}"
	)
	[[ ${PV} != 9999* ]] && makeenv+=("DRONE_TAG=${MY_PV}")

	if use build-client; then
		# -j1 as Makefile doesn't handle dependancy correctly, and is not
		# useful as golang compiler don't use this info.
		env "${makeenv[@]}" emake -j1 build
	else
		env "${makeenv[@]}" emake backend
	fi
}

src_install() {
	dobin gitea

	einstalldocs

	newconfd "${FILESDIR}/gitea.confd-r1" gitea
	newinitd "${FILESDIR}/gitea.initd-r3" gitea
	newtmpfiles - gitea.conf <<-EOF
		d /run/gitea 0755 git git
	EOF
	systemd_newunit "${FILESDIR}"/gitea.service-r2 gitea.service

	insinto /etc/gitea
	newins custom/conf/app.example.ini app.ini
	if use acct ; then
		fowners root:git /etc/gitea/{,app.ini}
		fperms g+w,o-rwx /etc/gitea/{,app.ini}

		diropts -m0750 -o git -g git
		keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
		keepdir /var/log/gitea
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst
	go-module_pkg_postinst
	tmpfiles_process gitea.conf
}
