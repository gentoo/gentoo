# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/inn/inn-2.5.5.ebuild,v 1.1 2015/06/09 05:32:30 jer Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib python-single-r1 ssl-cert toolchain-funcs

DESCRIPTION="The Internet News daemon, fully featured NNTP server"
HOMEPAGE="https://www.isc.org/software/inn"
SRC_URI="ftp://ftp.isc.org/isc/inn/${P}.tar.gz"

# GPL-2 only for init script
LICENSE="ISC GPL-2+ public-domain BSD-4 BSD-2 RSA BSD MIT GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="berkdb innkeywords inntaggedhash ipv6 kerberos perl python sasl ssl"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	virtual/mta
	dev-perl/MIME-tools
	sys-libs/pam
	sys-libs/zlib
	kerberos? ( virtual/krb5 )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( dev-libs/openssl )
	python? ( ${PYTHON_DEPS} )
	berkdb? ( sys-libs/db )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.5.3-ar.patch
	epatch "${FILESDIR}"/${PN}-2.5.3-tests.patch

	sed -e 's: -B .OLD::' -i Makefile.global.in || die

	# Do not treat LDFLAGS as if it contained libraries to link to
	sed -e 's:LDFLAGS::g' -i m4/python.m4 || die

	# We do not have the biff service, but we do have comsat
	sed -e 's:"biff":"comsat":g' -i tests/lib/getnameinfo-t.c || die

	eautoreconf
}

src_configure() {
	tc-export AR

	econf \
		--prefix=/usr/$(get_libdir)/news \
		--sysconfdir=/etc/news \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-control-dir=/usr/$(get_libdir)/news/bin/control \
		--with-filter-dir=/usr/$(get_libdir)/news/bin/filter \
		--with-db-dir=/var/spool/news/db \
		--with-doc-dir=/usr/share/doc/${PF} \
		--with-spool-dir=/var/spool/news \
		--with-log-dir=/var/log/news \
		--with-run-dir=/run/news \
		--with-tmp-dir=/var/spool/news/tmp \
		--disable-libtool \
		--with-gnu-ld \
		--enable-setgid-inews \
		--enable-uucp-rnews \
		$(use_with perl) \
		$(use_with python) \
		$(use_with kerberos kerberos /usr) \
		$(use_with sasl) \
		$(use_with ssl openssl) \
		$(use_with berkdb berkeleydb /usr) \
		$(use_enable ipv6) \
		$(use_enable !inntaggedhash largefiles) \
		$(use_enable inntaggedhash tagged-hash) \
		$(use_enable innkeywords keywords)
}

src_install() {
	emake DESTDIR="${D}/" P="" SPECIAL="" install

	chown -R root:0 \
		"${D}"/usr/$(get_libdir)/news/$(get_libdir) \
		"${D}"/usr/$(get_libdir)/news/include \
		"${D}"/usr/share/doc \
		"${D}"/usr/share/man \
		|| die
	chmod 644 "${D}"/etc/news/* || die
	chmod 640 \
		"${D}"/etc/news/control.ctl \
		"${D}"/etc/news/expire.ctl \
		"${D}"/etc/news/incoming.conf \
		"${D}"/etc/news/innfeed.conf \
		"${D}"/etc/news/nntpsend.ctl \
		"${D}"/etc/news/passwd.nntp \
		"${D}"/etc/news/readers.conf \
		|| die

	# Prevent old db/* files from being overwritten
	insinto /usr/share/inn/dbexamples
	newins site/active.minimal active
	newins site/newsgroups.minimal newsgroups

	keepdir \
		/var/log/news \
		/var/spool/news/archive \
		/var/spool/news/articles \
		/var/spool/news/db \
		/var/spool/news/incoming \
		/var/spool/news/incoming/bad \
		/var/spool/news/innfeed \
		/var/spool/news/outgoing \
		/var/spool/news/overview \
		/var/spool/news/tmp

	fowners news:news /var/log/news

	dodoc ChangeLog MANIFEST README* doc/checklist
	use ipv6 && dodoc doc/IPv6-info

	# So other programs can build against INN
	insinto /usr/$(get_libdir)/news/include
	doins include/*.h

	newinitd "${FILESDIR}"/innd-r1 innd
}

pkg_postinst() {
	for db_file in active newsgroups
	do
		[[ -f ${ROOT}var/spool/news/db/${db_file} ]] && continue

		if [[ -f ${ROOT}usr/share/inn/dbexamples/${db_file} ]]
		then
			cp "${ROOT}"usr/share/inn/dbexamples/${db_file} \
				"${ROOT}"var/spool/news/db/${db_file}
		else
			touch "${ROOT}"var/spool/news/db/${db_file}
		fi

		chown news:news "${ROOT}"var/spool/news/db/${db_file}
		chmod 664 "${ROOT}"var/spool/news/db/${db_file}
	done

	elog "It is recommended to run emerge --config ${CATEGORY}/${PN}"
	elog "now to finish setting up this package."
	elog
	elog "Do not forget to update your cron entries, and also run"
	elog "makedbz if you need to.  If this is a first-time installation"
	elog "a minimal active file has been installed.  You will need to"
	elog "touch history and run 'makedbz -i' to initialize the history"
	elog "database.  See INSTALL for more information."
	elog
	elog "You need to assign a real shell to the news user, or else"
	elog "starting inn will fail. You can use 'usermod -s /bin/bash news'"
	elog "for this."

	if use ssl
	then
		install_cert /etc/news/cert/cert
		chown news:news \
			"${ROOT}"etc/news/cert/cert.{crt,csr,key,pem}

		elog
		elog "You may want to start nnrpd manually for native ssl support."
		elog "If you choose to do so, automating this with a bootscript might"
		elog "also be a good choice."
		elog "Have a look at man nnrpd for valid parameters."
		elog
		elog "The certificate location in /etc/news/sasl.conf has been changed"
		elog "to /etc/news/cert!"

	fi
}

pkg_postrm() {
	elog
	elog "If you want your newsspool or altered configuration files"
	elog "to be removed, please do so now manually."
	elog
}

pkg_config() {
	NEWSSPOOL_DIR="${ROOT}var/spool/news"
	NEWS_SHELL="$( awk -F':' '/^news:/ {print $7;}' ${ROOT}etc/passwd )"
	NEWS_ERRFLAG="0"

	if [[ ${NEWS_SHELL} == /bin/false || ${NEWS_SHELL} == /dev/null ]]; then
		einfo "Changing shell to /bin/bash for user news..."
		usermod -s /bin/bash news
	else
		einfo "Shell for user news unchanged ('${NEWS_SHELL}')."
		if [[ ${NEWS_SHELL} != /bin/sh && ${NEWS_SHELL} != /bin/bash ]]; then
			ewarn "You might want to change it to '/bin/bash', though."
		fi
	fi

	if [[ ! -e ${NEWSSPOOL_DIR}/db/history ]]; then
		if [[ ! -f ${NEWSSPOOL_DIR}/db/history.dir \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.pag \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.hash \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.index ]]
		then
			einfo "Building history database ..."

			touch "${NEWSSPOOL_DIR}"/db/history
			chown news:news "${NEWSSPOOL_DIR}"/db/history
			chmod 644 "${NEWSSPOOL_DIR}"/db/history

			einfo "Running makedbz -i ..."
			su - news -c "/usr/$(get_libdir)/news/bin/makedbz -i"

			einfo "Moving files into place ..."
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.dir ]] && \
				mv -vf "${NEWSSPOOL_DIR}"/db/history.n.dir \
				"${NEWSSPOOL_DIR}"/db/history.dir
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.pag ]] && \
				mv -vf "${NEWSSPOOL_DIR}"/db/history.n.pag \
				"${NEWSSPOOL_DIR}"/db/history.pag
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.hash ]] && \
				mv -vf "${NEWSSPOOL_DIR}"/db/history.n.hash \
				"${NEWSSPOOL_DIR}"/db/history.hash
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.index ]] && \
				mv -vf "${NEWSSPOOL_DIR}"/db/history.n.index \
				"${NEWSSPOOL_DIR}"/db/history.index

			einfo "Running makehistory ..."
			su - news -c /usr/$(get_libdir)/news/bin/makehistory
		else
			NEWS_ERRFLAG="1"
			eerror "Your installation seems to be screwed up."
			eerror "${NEWSSPOOL_DIR}/db/history does not exist, but there's"
			eerror "one of the files history.dir, history.hash or history.index"
			eerror "within ${NEWSSPOOL_DIR}/db."
			eerror "Use your backup to restore the history database."
		fi
	else
		einfo "${NEWSSPOOL_DIR}/db/history found."
		einfo "Leaving history database as it is."
	fi

	INNCFG_INODES=$(
		sed /etc/news/inn.conf \
			-e '/innwatchspoolnodes/ ! d; s:[^ ]*[ ]*\([^ ]*\):\1:'
	)
	INNSPOOL_INODES=$(
		df -Pi ${NEWSSPOOL_DIR} | \
			sed -e 's:[^ ]*[ ]*\([^ ]*\).*:\1:; 1 d'
	)
	if [[ ${INNCFG_INODES} -gt ${INNSPOOL_INODES} ]]; then
		ewarn "Setting innwatchspoolinodes to zero, because the filesystem behind"
		ewarn "$NEWSSPOOL_DIR works without inodes."
		ewarn
		cp /etc/news/inn.conf /etc/news/inn.conf.OLD
		einfo "A copy of your old inn.conf has been saved to /etc/news/inn.conf.OLD."
		sed -i /etc/news/inn.conf \
			-e '/innwatchspoolnodes/ s:\([^ ]*\)\([ ]*\).*:\1\20:'
		chown news:news /etc/news/inn.conf
		chmod 644 /etc/news/inn.conf
	fi

	INNCHECK_LINES=$(
		su - news -c "/usr/$(get_libdir)/news/bin/inncheck | wc -l"
	)
	if [[ ${INNCHECK_LINES} -gt 0 ]]; then
		NEWS_ERRFLAG="1"
		ewarn "inncheck most certainly found an error."
		ewarn "Please check its output:"
		eerror "`su - news -c /usr/$(get_libdir)/news/bin/inncheck`"
	fi

	if [[ ${NEWS_ERRFLAG} -gt 0 ]]; then
		eerror "There were one or more errors/warnings checking your"
		eerror "configuration. Please read inn's documentation and"
		eerror "fix them accordingly."
	else
		einfo "INN configuration tests passed successfully."
		ewarn "Please ensure you have configured inn properly."
	fi
}
