# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="code.gitea.io/gitea/..."
EGIT_COMMIT="8559d6f267324241496b8611bc8e6f76efe869b7"
ARCHIVE_URI="https://github.com/go-gitea/gitea/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A painless self-hosted Git service, written in Go, forked from gogs"
HOMEPAGE="https://github.com/go-gitea/gitea"
SRC_URI="${ARCHIVE_URI}"

LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/go-bindata"
RDEPEND="dev-vcs/git"

pkg_setup() {
	enewgroup gitea
	enewuser gitea -1 /bin/bash /var/lib/gitea gitea
}

src_prepare() {
	default
	local GITEA_PREFIX=${EPREFIX}/var/lib/gitea
	sed -i -e "s/git rev-parse --short HEAD/echo ${EGIT_COMMIT:0:7}/"\
		-e "s/^VERSION =*/VERSION = ${PV}/"\
		-e "s/-ldflags '-s/-ldflags '/" src/${EGO_PN%/*}/Makefile || die
	sed -i -e "s#RUN_USER = git#RUN_USER = gitea#"\
		-e "s#^STATIC_ROOT_PATH =#STATIC_ROOT_PATH = ${EPREFIX}/usr/share/themes/gitea/default#"\
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${GITEA_PREFIX}/data#"\
		-e "s#^PATH = data/gitea.db#PATH = ${GITEA_PREFIX}/data/gitea.db#"\
		-e "s#^PROVIDER_CONFIG = data/sessions#PROVIDER_CONFIG = ${GITEA_PREFIX}/data/sessions#"\
		-e "s#^AVATAR_UPLOAD_PATH = data/avatars#AVATAR_UPLOAD_PATH = ${GITEA_PREFIX}/data/avatars#"\
		-e "s#^TEMP_PATH = data/tmp/uploads#TEMP_PATH = ${GITEA_PREFIX}/data/tmp/uploads#"\
		-e "s#^PATH = data/attachements#PATH = ${GITEA_PREFIX}/data/attachements#"\
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#" src/${EGO_PN%/*}/conf/app.ini || die
}

src_compile() {
	TAGS="cert pam sqlite" LDFLAGS="" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C src/${EGO_PN%/*} generate build || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin gitea
	insinto /usr/share/gitea
	doins -r conf
	insinto /usr/share/themes/gitea/default
	doins -r public templates
	popd || die
	keepdir /var/log/gitea /var/lib/gitea/data
	fowners gitea:gitea /var/log/gitea /var/lib/gitea
}
