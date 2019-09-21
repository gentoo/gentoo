# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ssl-cert user

MY_PV="${PV/_p/p}"
DESCRIPTION="Daemon for Sguil Network Security Monitoring"
HOMEPAGE="https://github.com/bammv/sguil"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P/-server}.tar.gz"

LICENSE="GPL-2 QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="
	>=dev-lang/tcl-8.3:0=[-threads]
	>=dev-tcltk/tclx-8.3
	dev-tcltk/tcllib
	dev-tcltk/mysqltcl
	ssl? ( >=dev-tcltk/tls-1.4.1 )
"
RDEPEND="
	${DEPEND}
	net-analyzer/p0f
	net-analyzer/tcpflow
	net-misc/openssh
"

S="${WORKDIR}/sguil-${MY_PV}"

pkg_setup() {
	enewgroup sguil
	enewuser sguil -1 -1 /var/lib/sguil sguil
}

src_prepare(){
	default
	sed -i \
		-e 's:DEBUG 2:DEBUG 1:' -e 's:DAEMON 0:DAEMON 1:' \
		-e 's:SGUILD_LIB_PATH ./lib:SGUILD_LIB_PATH /usr/'$(get_libdir)'/sguild:g' \
		-e 's:/sguild_data/rules:/var/lib/sguil/rules:g' \
		-e 's:/sguild_data/archive:/var/lib/sguil/archive:g' \
		server/sguild.conf || die
}

src_install(){
	dodoc server/sql_scripts/*
	dodoc doc/CHANGES doc/OPENSSL.README doc/USAGE doc/INSTALL \
	doc/TODO doc/sguildb.dia

	insopts -m640
	insinto /etc/sguil
	doins server/{sguild.email,sguild.users,sguild.conf,sguild.queries,sguild.access,autocat.conf}

	insinto /usr/$(get_libdir)/sguild
	doins server/lib/*
	dobin server/sguild
	newinitd "${FILESDIR}/sguild.initd" sguild
	newconfd "${FILESDIR}/sguild.confd" sguild

	if use ssl; then
		sed -i -e "s/#OPENSSL/OPENSSL/" "${D}/etc/conf.d/sguild"
	fi

	diropts -g sguil -o sguil
	keepdir \
		/var/lib/sguil \
		/var/lib/sguil/archive \
		/var/lib/sguil/rules

}

pkg_postinst(){
	if use ssl && ! [ -f "${ROOT}"/etc/sguil/sguild.key ]; then
		install_cert /etc/sguil/sguild
	fi

	chown -R sguil:sguil "${ROOT}"/etc/sguil/sguild.*
	chown -R sguil:sguil "${ROOT}"/usr/lib/sguild

	if [ -d "${ROOT}"/etc/snort/rules ] ; then
		ln -s /etc/snort/rules "${ROOT}"/var/lib/sguil/rules/${HOSTNAME}
	fi

	elog
	elog "Please customize the sguild configuration files in /etc/sguild before"
	elog "trying to run the daemon. Additionally you will need to setup the"
	elog "mysql database. See /usr/share/doc/${PF}/INSTALL.gz for information."
	elog "Please note that it is STRONGLY recommended to mount a separate"
	elog "filesystem at /var/lib/sguil for both space and performance reasons"
	elog "as a large amount of data will be kept in the directory structure"
	elog "underneath that top directory."
	elog
	elog "You should create the sguild db as per the install instructions in"
	elog "/usr/share/doc/${PF}/ and use the appropriate"
	elog "database setup script located in the same directory."

	elog
}
