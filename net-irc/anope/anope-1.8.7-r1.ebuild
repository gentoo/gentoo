# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/anope/anope-1.8.7-r1.ebuild,v 1.2 2013/02/18 18:48:48 gurligebis Exp $

EAPI=4

inherit autotools eutils multilib versionator user

DESCRIPTION="Anope IRC Services"
HOMEPAGE="http://www.anope.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql"

DEPEND="mysql? ( virtual/mysql )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	local replaced_version
	for replaced_version in ${REPLACING_VERSIONS} ; do
		if ! version_is_at_least 1.8.7 ${replaced_version} && [[ -f ${ROOT}opt/anope/data/nick.db ]]; then
			eerror "It looks like you have an older version of Anope installed."
			eerror "To upgrade, shut down Anope and copy your databases to"
			eerror "${ROOT}var/lib/anope and your configuration to ${ROOT}etc/anope"
			eerror "You can do this by:"
			eerror "# mkdir -p ${ROOT}var/lib/anope ${ROOT}etc/anope"
			eerror "# chown anope:anope ${ROOT}var/lib/anope"
			eerror "# mv ${ROOT}opt/anope/data/*.db ${ROOT}var/lib/anope"
			eerror "# mv ${ROOT}opt/anope/data/services.conf ${ROOT}etc/anope"
			die "Please move your anope database files from /opt/anope/data"
		fi
	done
}

pkg_setup() {
	enewgroup anope
	enewuser anope -1 -1 -1 anope
}

src_prepare() {
	epatch "${FILESDIR}/pid-patch.diff"
	epatch "${FILESDIR}/${P}-ldflags-fix.patch"
	epatch "${FILESDIR}/${P}-libdir-gentoo.patch"
	epatch "${FILESDIR}"/${P}-mariadb.patch # bug 381119
	eautoconf
}

src_configure() {
	local myconf
	if ! use mysql; then
		myconf="${myconf} --without-mysql"
	fi

	econf \
		${myconf} \
		--with-bindir=/usr/bin/ \
		--with-datadir=/var/lib/anope \
		--with-libdir=/usr/$(get_libdir)/anope/ \
		--with-rungroup=anope \
		--with-permissions=077

	sed -i -e "/^build:/s:$: language:g" "${S}"/Makefile || die "sed failed"
}

src_install() {
	keepdir /var/log/anope /var/lib/anope/backups
	fowners anope:anope /var/{lib,log}/anope /var/lib/anope/backups

	local baselibdir
	baselibdir="${D}/usr/$(get_libdir)/anope"

	dodir /usr/$(get_libdir)/anope/{lang,modules}
	emake DATDEST="${baselibdir}" \
		BINDEST="${D}/usr/bin" \
		MODULE_PATH="${baselibdir}/modules" \
		install

	newinitd "${FILESDIR}/anope-init.d" anope
	newconfd "${FILESDIR}/anope-conf.d" anope

	dodoc Changes Changes.conf Changes.lang Changes.mysql docs/* data/example.conf
	use mysql && dodoc data/tables.sql

	insinto /etc/anope
	newins data/example.conf services.conf
}

pkg_preinst() {
	if has_version net-irc/anope ; then
		local directory
		directory="${ROOT}"var/lib/anope/pre-update
		elog "Making a backup of your databases to ${directory}"
		if [ ! -d "${directory}" ]; then
			mkdir -p "${directory}" || die "failed to create backup directory"
			chown anope:anope "${directory}"/../ || die "failed to chown data directory"
		fi
		# don't die otherwise merge will fail if there are no existing databases
		cp "${ROOT}"/var/lib/anope/*.db "${directory}"
	fi
}

pkg_postinst() {
	echo
	ewarn "Anope won't run out of the box, you still have to configure it to match your IRCD's configuration."
	ewarn "Edit /etc/anope/services.conf to configure Anope."

	if use mysql; then
		echo
		ewarn "!!! ATTENTION !!!"
		ewarn "Be sure to read Changes.mysql to update your MySQL"
		ewarn "tables or anope will break after restart"
		ewarn "!!! ATTENTION !!!"
		echo
		einfo "The mysql script for updating the tables is located in the"
		einfo "/usr/share/doc/${PF} directory"
	fi
}
