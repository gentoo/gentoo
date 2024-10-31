# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs systemd tmpfiles

DESCRIPTION="coturn TURN server project"
HOMEPAGE="https://github.com/coturn/coturn"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/coturn/coturn.git"
	inherit git-r3
else
	SRC_URI="https://github.com/coturn/coturn/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="mongodb mysql postgres redis sqlite"

DEPEND="
	>dev-libs/libevent-2.1.8:=[ssl]
	dev-libs/openssl:=
	mongodb? (
		dev-libs/libbson
		dev-libs/mongo-c-driver
	)
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	redis? ( dev-libs/hiredis:= )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="
	${DEPEND}
	acct-group/turnserver
	acct-user/turnserver
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.2-respect-TMPDIR.patch
)

src_configure() {
	sed -e '/MANPREFIX/s:/man/:/:' \
		-e '/INSTALL_DIR} examples\/script/a \	\${INSTALL_DIR} examples\/ca \${DESTDIR}${EXAMPLESDIR}' \
		-e '/INSTALL_STATIC_LIB/d' \
		-i "Makefile.in" || die "sed for Makefile.in failed"

	sed -e 's:#log-file=/var/tmp/turn.log:log-file=/var/log/turnserver.log:' \
		-e 's:#simple-log:simple-log:' \
		-i "examples/etc/turnserver.conf"  || die "sed for turnserve.conf failed"

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
	export DOCSDIR="/usr/share/doc/${PF}"

	econf $(use_with sqlite)
}

src_install() {
	default

	keepdir /var/lib/db

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
