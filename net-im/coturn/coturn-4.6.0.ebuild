# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs systemd tmpfiles

DESCRIPTION="coturn TURN server project"
HOMEPAGE="https://github.com/coturn/coturn"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/coturn/coturn.git"
	inherit git-r3
	#S="${WORKDIR}/${PN}-master"
else
	SRC_URI="https://github.com/coturn/coturn/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="mongodb mysql postgres redis sqlite"

RDEPEND="
	acct-group/turnserver
	acct-user/turnserver
	>dev-libs/libevent-2.1.8:=
	dev-libs/openssl:=
	mongodb? ( dev-libs/mongo-c-driver )
	mysql?  ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	redis? ( dev-libs/hiredis:= )
	sqlite? ( dev-db/sqlite )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.2-respect-TMPDIR.patch
	"${FILESDIR}"/${P}-openssl3.patch
)

src_configure() {
	if [[ -n "${AR}" ]]; then
		sed 's:ARCHIVERCMD="ar -r":ARCHIVERCMD="${AR} -r":g' -i "${S}/configure"
	fi

	sed 's:MANPREFIX}/man/:MANPREFIX}/:g' -i "${S}/Makefile.in" || die "sed for mandir failed"
	sed 's:#log-file=/var/tmp/turn.log:log-file=/var/log/turnserver.log:' \
	    -i "${S}/examples/etc/turnserver.conf"  || die "sed for logdir failed"
	sed 's:#simple-log:simple-log:' -i "${S}/examples/etc/turnserver.conf" \
	    || die "sed for simple-log failed"
	sed '/INSTALL_DIR} examples\/script/a \	\${INSTALL_DIR} examples\/ca \${DESTDIR}${EXAMPLESDIR}' \
	    -i "${S}/Makefile.in" || die "sed for example ca failed"

	if ! use mongodb; then
		export TURN_NO_MONGO=yes
	fi
	if ! use mysql; then
		export TURN_NO_MYSQL=yes
	fi
	if ! use postgres; then
		export TURN_NO_PQ=yes
	fi
	if ! use redis; then
		export TURN_NO_HIREDIS=yes
	fi
	if ! use sqlite; then
		export TURN_NO_SQLITE=yes
	fi

	tc-export CC

	export ARCHIVERCMD="$(tc-getAR) -r"
	export PKGCONFIG="$(tc-getPKG_CONFIG)"
	export DOCSDIR="/usr/share/doc/${PN}-${PV}"

	econf $(use_with sqlite)
}

src_install() {
	default

	newinitd "${FILESDIR}/turnserver.init" turnserver

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.${PN}" "${PN}"

	systemd_dounit "${FILESDIR}/${PN}.service"
	dotmpfiles "${FILESDIR}/${PN}.conf"
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	elog "You need to copy ${EROOT}/etc/turnserver.conf.default to"
	elog "${EROOT}/etc/turnserver.conf and do your settings there."
}
