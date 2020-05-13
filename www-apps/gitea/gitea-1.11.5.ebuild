# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != 9999* ]] ; then
	SCM="golang-vcs-snapshot"
else
	SCM="git-r3"
fi

inherit fcaps golang-base tmpfiles systemd ${SCM}
unset SCM

EGO_PN="code.gitea.io/gitea"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io"

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/go-gitea/gitea/releases/download/v${PV}/gitea-src-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64"
else
	EGIT_REPO_URI="https://github.com/go-gitea/gitea"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
	has test ${FEATURES} && EGIT_MIN_CLONE_TYPE="mirror"
fi

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
IUSE="+acct build-client pam sqlite"

BDEPEND="dev-lang/go
	build-client? ( >=net-libs/nodejs-10[npm] )"
DEPEND="pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	acct? (
		acct-group/git
		acct-user/git[gitea]
	)
	dev-vcs/git"

DOCS=( custom/conf/app.ini.sample CONTRIBUTING.md README.md )
FILECAPS=( cap_net_bind_service+ep usr/bin/gitea )
S="${WORKDIR}/${P}/src/${EGO_PN}"

PATCHES=( "${FILESDIR}/gitea-logflags.patch" )

gitea_make() {
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
		TAGS="${gitea_tags[@]}"
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[@]}"
		GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"
	)
	[[ ${PV} != 9999* ]] && makeenv+=("DRONE_TAG=${PV}")

	env "${makeenv[@]}" emake -j1 "$@"
}

src_prepare() {
	default

	local sedcmds=(
		-e "s#^RUN_MODE = dev#RUN_MODE = prod#"
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/gitea/gitea-repositories#"
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/gitea/data#"
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"
		-e "s#^MODE = console#MODE = file#"
		-e "s#^LEVEL = Trace#LEVEL = Info#"
		-e "s#^LOG_SQL = true#LOG_SQL = false#"
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"
		-e "s#^APP_ID =#;APP_ID =#"
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#"
	)

	sed -i "${sedcmds[@]}" custom/conf/app.ini.sample || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.ini.sample || die
	fi

	# Remove already build assets (like frontend part)
	use build-client && gitea_make clean-all
}

src_compile() {
	if use build-client ; then
		gitea_make build
	else
		gitea_make backend
	fi
}

src_test() {
	if has network-sandbox ${FEATURES}; then
		einfo "Remove tests which are known to fail with network-sandbox enabled."
		rm ./modules/migrations/github_test.go || die
	fi

	if [[ ${PV} != 9999* ]] ; then
		einfo "Remove tests which depend on gitea git-repo."
		rm ./modules/git/blob_test.go || die
		rm ./modules/git/repo_test.go || die
	fi

	default
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
	newins custom/conf/app.ini.sample app.ini
	if use acct ; then
		fowners root:git /etc/gitea/{,app.ini}
		fperms g+w,o-rwx /etc/gitea/{,app.ini}

		diropts -m0750 -o git -g git
		keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
		keepdir /var/log/gitea
	fi
}
