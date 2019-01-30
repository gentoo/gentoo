# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64 ~arm"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://gitea.io/"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="pam sqlite"

S="${WORKDIR}/${P}/src/${EGO_PN}"

PATCHES=(
	"${FILESDIR}/fix-chpw-loop.patch"
)
COMMON_DEPEND="pam? ( sys-libs/pam )"

DEPEND="
	${COMMON_DEPEND}
	dev-go/go-bindata
"
RDEPEND="
	${COMMON_DEPEND}
	dev-vcs/git
"

GITEA_USER=git
GITEA_GROUP=git

pkg_setup() {
	enewgroup ${GITEA_GROUP}
	enewuser ${GITEA_USER} -1 /bin/bash /var/lib/gitea ${GITEA_GROUP}
}

gitea_make() {
	local my_tags=(
		bindata
		$(usev pam)
		$(usex sqlite 'sqlite sqlite_unlock_notify' '')
	)
	local my_makeopt=(
		DRONE_TAG=${PV}
		TAGS="${my_tags[@]}"
	)
	GOPATH=${WORKDIR}/${P}:$(get_golibdir_gopath) emake "${my_makeopt[@]}" $1 || die "make $1 failed"
}

src_prepare() {
	default
	sed -i -e "s/-ldflags '-s/-ldflags '/" \
		-e "s/GOFLAGS := -i -v/GOFLAGS := -v/" \
		Makefile || die
	sed -i -e "s#^RUN_MODE = dev#RUN_MODE = prod#" \
		-e "s#^LOG_SQL = true#LOG_SQL = false#" \
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#" \
		-e "s#^MODE = console#MODE = console, file#" \
		-e "s#^LEVEL = Trace#LEVEL = Info#" \
		-e "s#^APP_ID =#;APP_ID =#" \
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#" \
		custom/conf/app.ini.sample || die
	gitea_make generate
}

src_compile() {
	gitea_make build
}

src_test() {
	gitea_make test

}

src_install() {
	dobin gitea

	diropts -m0750 -o git -g git
	keepdir /var/log/gitea /var/lib/gitea /var/lib/gitea/data
	insinto /var/lib/gitea/conf
	doins custom/conf/app.ini.sample
	newinitd "${FILESDIR}"/gitea.initd gitea
	newconfd "${FILESDIR}"/gitea.confd gitea
	systemd_dounit "${FILESDIR}"/gitea.service
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/var/lib/gitea/conf/app.ini" ]] ; then
		elog "No app.ini found, copying initial config over"
		cp "${EROOT}"/var/lib/gitea/conf/{app.ini.sample,app.ini} || die
		chown ${GITEA_USER}:${GITEA_GROUP} "${EROOT}/var/lib/gitea/conf/app.ini"
	else
		elog "app.ini found, please check example file for possible changes"
		ewarn "Please note that environment variables have been changed:"
		ewarn "GITEA_WORK_DIR is set to /var/lib/gitea (previous value: unset)"
		ewarn "GITEA_CUSTOM is set to '\$GITEA_WORK_DIR/custom' (previous: /var/lib/gitea)"
	fi
}
