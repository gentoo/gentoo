# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64 ~arm"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://github.com/go-gitea/gitea"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	dev-go/go-bindata
	sys-libs/pam
"
RDEPEND="
	dev-vcs/git
	sys-libs/pam
"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

src_prepare() {
	default
	sed -i -e "s/\"main.Version.*$/\"main.Version=${PV}\"/"\
		-e "s/-ldflags '-s/-ldflags '/" \
		-e "s/GOFLAGS := -i -v/GOFLAGS := -v/" \
		"src/${EGO_PN}/Makefile" || die
	local GITEA_PREFIX="${EPREFIX}/var/lib/gitea"
	sed -i -e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${GITEA_PREFIX}/data#"\
		-e "s#^PATH = data/gitea.db#PATH = ${GITEA_PREFIX}/data/gitea.db#"\
		-e "s#^PROVIDER_CONFIG = data/sessions#PROVIDER_CONFIG = ${GITEA_PREFIX}/data/sessions#"\
		-e "s#^AVATAR_UPLOAD_PATH = data/avatars#AVATAR_UPLOAD_PATH = ${GITEA_PREFIX}/data/avatars#"\
		-e "s#^TEMP_PATH = data/tmp/uploads#TEMP_PATH = ${GITEA_PREFIX}/data/tmp/uploads#"\
		-e "s#^PATH = data/attachments#PATH = ${GITEA_PREFIX}/data/attachments#"\
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"\
		-e "s#^ISSUE_INDEXER_PATH =#ISSUE_INDEXER_PATH = ${GITEA_PREFIX}/indexers/issues.bleve#"\
		"src/${EGO_PN}/custom/conf/app.ini.sample" || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C "src/${EGO_PN}" generate
	TAGS="bindata pam sqlite" LDFLAGS="" CGO_LDFLAGS="-fno-PIC" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C "src/${EGO_PN}" build
}

src_install() {
	diropts -m0750 -o git -g git
	keepdir /var/log/gitea /var/lib/gitea /var/lib/gitea/data
	pushd "src/${EGO_PN}" >/dev/null || die
	dobin gitea
	insinto /var/lib/gitea/conf
	doins custom/conf/app.ini.sample
	popd >/dev/null || die
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/gitea.logrotated gitea
	newinitd "${FILESDIR}"/gitea.initd-r1 gitea
	newconfd "${FILESDIR}"/gitea.confd gitea
	systemd_dounit "${FILESDIR}/gitea.service"
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/var/lib/gitea/conf/app.ini" ]]; then
		elog "No app.ini found, copying initial config over"
		cp "${FILESDIR}"/app.ini "${EROOT}"/var/lib/gitea/conf/ || die
		chown git:git /var/lib/gitea/conf/app.ini
	else
		elog "app.ini found, please check example file for possible changes"
		ewarn "Please note that environment variables have been changed:"
		ewarn "GITEA_WORK_DIR is set to /var/lib/gitea (previous value: unset)"
		ewarn "GITEA_CUSTOM is set to '\$GITEA_WORK_DIR/custom' (previous: /var/lib/gitea)"
	fi
}
