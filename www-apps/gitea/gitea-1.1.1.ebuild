# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="code.gitea.io/gitea/..."
GIT_COMMIT="f9859a2"
ARCHIVE_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://github.com/go-gitea/gitea"
SRC_URI="${ARCHIVE_URI}"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata"
RDEPEND="dev-vcs/git"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

src_prepare() {
	default
	local GITEA_PREFIX=${EPREFIX}/var/lib/gitea
	sed -i -e "s/git rev-parse --short HEAD/echo ${GIT_COMMIT}/"\
		-e "s/^LDFLAGS += -X \"main.Version.*$/LDFLAGS += -X \"main.Version=${PV}\"/"\
		-e "s/-ldflags '-s/-ldflags '/" src/${EGO_PN%/*}/Makefile || die
	sed -i -e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${GITEA_PREFIX}/data#"\
		-e "s#^PATH = data/gitea.db#PATH = ${GITEA_PREFIX}/data/gitea.db#"\
		-e "s#^PROVIDER_CONFIG = data/sessions#PROVIDER_CONFIG = ${GITEA_PREFIX}/data/sessions#"\
		-e "s#^AVATAR_UPLOAD_PATH = data/avatars#AVATAR_UPLOAD_PATH = ${GITEA_PREFIX}/data/avatars#"\
		-e "s#^TEMP_PATH = data/tmp/uploads#TEMP_PATH = ${GITEA_PREFIX}/data/tmp/uploads#"\
		-e "s#^PATH = data/attachments#PATH = ${GITEA_PREFIX}/data/attachments#"\
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"\
		-e "s#^ISSUE_INDEXER_PATH =#ISSUE_INDEXER_PATH = ${GITEA_PREFIX}/indexers/issues.bleve#"\
		src/${EGO_PN%/*}/conf/app.ini || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C src/${EGO_PN%/*} generate
	TAGS="bindata pam sqlite" LDFLAGS="" CGO_LDFLAGS="-fno-PIC" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C src/${EGO_PN%/*} build
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin gitea
	insinto /var/lib/gitea/conf
	newins conf/app.ini app.ini.example
	popd || die
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/gitea.logrotated gitea
	newinitd "${FILESDIR}"/gitea.initd gitea
	newconfd "${FILESDIR}"/gitea.confd gitea
	keepdir /var/log/gitea /var/lib/gitea/data
	fowners -R git:git /var/log/gitea /var/lib/gitea/
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/var/lib/gitea/conf/app.ini ]]; then
		elog "No app.ini found, copying the example over"
		cp "${EROOT}"/var/lib/gitea/conf/app.ini{.example,} || die
	else
		elog "app.ini found, please check example file for possible changes"
	fi
}
