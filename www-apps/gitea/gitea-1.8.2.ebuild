# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="pam sqlite"

COMMON_DEPEND="pam? ( sys-libs/pam )"
DEPEND="${COMMON_DEPEND}
	dev-go/go-bindata"
RDEPEND="${COMMON_DEPEND}
	dev-vcs/git"

DOCS=( custom/conf/app.ini.sample CONTRIBUTING.md README.md )
S="${WORKDIR}/${P}/src/${EGO_PN}"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
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
	GOPATH=${WORKDIR}/${P}:$(get_golibdir_gopath) emake "${my_makeopt[@]}" "$@"
}

src_prepare() {
	default
	sed -i \
		-e "s#^RUN_MODE = dev#RUN_MODE = prod#"                                     \
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/gitea/gitea-repositories#"          \
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"                   \
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/gitea/data#" \
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"                          \
		-e "s#^MODE = console#MODE = file#"                                         \
		-e "s#^LEVEL = Trace#LEVEL = Info#"                                         \
		-e "s#^LOG_SQL = true#LOG_SQL = false#"                                     \
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"               \
		-e "s#^APP_ID =#;APP_ID =#"                                                 \
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#"                                 \
		custom/conf/app.ini.sample || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.ini.sample || die
	fi

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

	einstalldocs

	newconfd "${FILESDIR}"/gitea.confd-r1 gitea
	newinitd "${FILESDIR}"/gitea.initd-r3 gitea
	systemd_newunit "${FILESDIR}"/gitea.service-r2 gitea.service

	insinto /etc/gitea
	newins custom/conf/app.ini.sample app.ini
	fowners root:git /etc/gitea/{,app.ini}
	fperms g+w,o-rwx /etc/gitea/{,app.ini}

	diropts -m0750 -o git -g git
	keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
	keepdir /var/log/gitea
}

pkg_postinst() {
	if [[ -e "${EROOT}/var/lib/gitea/conf/app.ini" ]]; then
		ewarn "The configuration path has been changed to ${EROOT}/etc/gitea/app.ini."
		ewarn "Please move your configuration from ${EROOT}/var/lib/gitea/conf/app.ini"
		ewarn "and adapt the gitea-repositories hooks and ssh authorized_keys."
		ewarn "Depending on your configuration you should run something like:"
		ewarn "sed -i -e 's#${EROOT}/var/lib/gitea/conf/app.ini#${EROOT}/etc/gitea/app.ini#' \\"
		ewarn "  /var/lib/gitea/gitea-repositories/*/*/hooks/*/* \\"
		ewarn "  /var/lib/gitea/.ssh/authorized_keys"
	fi
}
