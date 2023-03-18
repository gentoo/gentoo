# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qmail.eclass
# @MAINTAINER:
# Rolf Eike Beer <eike@sf-mail.de>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: common qmail functions

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_QMAIL_ECLASS} ]]; then
_QMAIL_ECLASS=1

inherit flag-o-matic toolchain-funcs fixheadtails

# hardcoded paths
QMAIL_HOME="/var/qmail"
TCPRULES_DIR="/etc/tcprules.d"
SUPERVISE_DIR="/var/qmail/supervise"

# source files and directories
GENQMAIL_F=genqmail-${GENQMAIL_PV}.tar.bz2
GENQMAIL_S="${WORKDIR}"/genqmail-${GENQMAIL_PV}

QMAIL_SPP_F=qmail-spp-${QMAIL_SPP_PV}.tar.gz
QMAIL_SPP_S="${WORKDIR}"/qmail-spp-${QMAIL_SPP_PV}

# @FUNCTION: is_prime
# @USAGE: <number>
# @DESCRIPTION:
# Checks wether a number is a valid prime number for queue split
is_prime() {
	local number=${1} i

	if [[ ${number} -lt 7 ]]; then
		# too small
		return 1
	fi

	if [[ $[number % 2] == 0 ]]; then
		return 1
	fi

	# let i run up to the square root of number
	for ((i = 3; i * i <= number; i += 2))
	do
		if [[ $[number % i ] == 0 ]]; then
			return 1
		fi
	done

	return 0
}

dospp() {
	exeinto "${QMAIL_HOME}"/plugins/
	newexe ${1} ${2:-${1##*/}}
}

# @FUNCTION: dosupervise
# @USAGE: <service> [<runfile> <logfile>]
# @DESCRIPTION:
# Install runfiles for services and logging to supervise directory
dosupervise() {
	local service=$1
	local runfile=${2:-${service}} logfile=${3:-${service}-log}
	[[ -z ${service} ]] && die "no service given"

	dodir ${SUPERVISE_DIR}/${service}{,/log}
	fperms +t ${SUPERVISE_DIR}/${service}{,/log}

	exeinto ${SUPERVISE_DIR}/${service}
	newexe ${runfile} run

	exeinto ${SUPERVISE_DIR}/${service}/log
	newexe ${logfile} run
}

# @FUNCTION: qmail_set_cc
# @DESCRIPTION:
# The following commands patch the conf-{cc,ld} files to use the user's
# specified CFLAGS and LDFLAGS. These rather complex commands are needed
# because a user supplied patch might apply changes to these files, too.
# See bug #165981.
qmail_set_cc() {
	local cc=$(head -n 1 ./conf-cc | sed -e "s#^g\?cc\s\+\(-O2\)\?#$(tc-getCC) #")
	local ld=$(head -n 1 ./conf-ld | sed -e "s#^g\?cc\s\+\(-s\)\?#$(tc-getCC) #")

	echo "${cc} ${CFLAGS} ${CPPFLAGS}"  > ./conf-cc || die 'Patching conf-cc failed.'
	echo "${ld} ${LDFLAGS}" > ./conf-ld || die 'Patching conf-ld failed.'
	sed -e "s#'ar #'$(tc-getAR) #" -e "s#'ranlib #'$(tc-getRANLIB) #" -i make-makelib.sh || die
}

genqmail_src_unpack() {
	cd "${WORKDIR}" || die
	[[ -n ${GENQMAIL_PV} ]] && unpack "${GENQMAIL_F}"
}

qmail_spp_src_unpack() {
	cd "${WORKDIR}" || die
	[[ -n ${QMAIL_SPP_PV} ]] && unpack "${QMAIL_SPP_F}"
}

# @FUNCTION: qmail_src_postunpack
# @DESCRIPTION:
# Unpack common config files, and set built configuration (CFLAGS, LDFLAGS, etc)
qmail_src_postunpack() {
	cd "${S}" || die

	qmail_set_cc

	mysplit=${QMAIL_CONF_SPLIT:-23}
	is_prime ${mysplit} || die "QMAIL_CONF_SPLIT is not a prime number."
	einfo "Using conf-split value of ${mysplit}."
	echo -n ${mysplit} > "${S}"/conf-split || die
}

qmail_src_compile() {
	cd "${S}" || die
	emake it man "$@"
}

qmail_spp_src_compile() {
	cd "${GENQMAIL_S}"/spp/ || die
	emake
}

qmail_base_install() {
	# subshell to not leak the install options
	(
	einfo "Setting up basic directory hierarchy"
	diropts -o 0 -g qmail
	dodir "${QMAIL_HOME}"/bin
	keepdir "${QMAIL_HOME}"/{control,users}
	diropts -o alias -g qmail
	keepdir "${QMAIL_HOME}"/alias

	einfo "Adding env.d entry for qmail"
	doenvd "${GENQMAIL_S}"/conf/99qmail

	einfo "Installing all qmail software"
	exeinto "${QMAIL_HOME}"/bin

	exeopts -o 0 -g qmail
	doexe bouncesaying condredirect config-fast datemail except forward maildir2mbox \
		maildirmake mailsubj predate preline qbiff \
		qmail-{inject,qmqpc,qmqpd,qmtpd,qread,qstat,smtpd,tcpok,tcpto,showctl} \
		qreceipt sendmail tcp-env

	# obsolete tools, install if they are still present
	local i
	for i in elq maildirwatch pinq qail qsmhook; do
		[[ -x ${i} ]] && doexe ${i}
	done

	use pop3 && doexe qmail-pop3d

	exeopts -o 0 -g qmail -m 711
	doexe qmail-{clean,getpw,local,pw2u,remote,rspawn,send} splogger
	use pop3 && doexe qmail-popup

	exeopts -o 0 -g qmail -m 700
	doexe qmail-{lspawn,newmrh,newu,start}

	exeopts -o qmailq -g qmail -m 4711
	doexe qmail-queue
	)
}

qmail_config_install() {
	einfo "Installing stock configuration files"
	insinto "${QMAIL_HOME}"/control
	doins "${GENQMAIL_S}"/control/{conf-*,defaultdelivery}

	einfo "Installing configuration sanity checker and launcher"
	insinto "${QMAIL_HOME}"/bin
	doins "${GENQMAIL_S}"/control/qmail-config-system
}

qmail_man_install() {
	einfo "Installing manpages and documentation"

	into /usr
	doman *.[1578]
	dodoc BLURB* INSTALL* PIC* README* REMOVE* \
		SENDMAIL* TEST* THANKS* VERSION*
	# notqmail converted the files to markdown
	if [[ -f CHANGES ]]; then
		dodoc CHANGES FAQ SECURITY THOUGHTS UPGRADE
	else
		dodoc CHANGES.md FAQ.md SECURITY.md THOUGHTS.md UPGRADE.md
	fi
}

qmail_sendmail_install() {
	einfo "Installing sendmail replacement"
	dodir /usr/sbin /usr/lib

	dosym "${QMAIL_HOME}"/bin/sendmail /usr/sbin/sendmail
	dosym "${QMAIL_HOME}"/bin/sendmail /usr/lib/sendmail
}

qmail_maildir_install() {
	# subshell to not leak the install options
	(
	# use the correct maildirmake
	# the courier-imap one has some extensions that are nicer
	MAILDIRMAKE="${D}${QMAIL_HOME}/bin/maildirmake"
	[[ -e /usr/bin/maildirmake ]] && \
		MAILDIRMAKE="/usr/bin/maildirmake"

	einfo "Setting up default maildirs in the account skeleton"
	diropts -m 700
	insinto /etc/skel
	newins "${GENQMAIL_S}"/control/defaultdelivery .qmail.example
	"${MAILDIRMAKE}" "${D}"/etc/skel/.maildir
	keepdir /etc/skel/.maildir/{cur,new,tmp}

	einfo "Setting up the default aliases"
	diropts -o alias -g qmail -m 700
	"${MAILDIRMAKE}" "${D}${QMAIL_HOME}"/alias/.maildir
	keepdir "${QMAIL_HOME}"/alias/.maildir/{cur,new,tmp}

	local i
	for i in "${QMAIL_HOME}"/alias/.qmail-{mailer-daemon,postmaster,root}; do
		if [[ ! -f ${ROOT}${i} ]]; then
			touch "${D}${i}"
			fowners alias:qmail "${i}"
		fi
	done
	)
}

qmail_tcprules_install() {
	dodir "${TCPRULES_DIR}"
	insinto "${TCPRULES_DIR}"
	doins "${GENQMAIL_S}"/tcprules/Makefile.qmail
	doins "${GENQMAIL_S}"/tcprules/tcp.qmail-*
	rm -f "${D}${TCPRULES_DIR}"/tcp.qmail-pop3sd || die
}

qmail_supervise_install_one() {
	dosupervise ${1}
	# subshell to not leak the install options
	(
	diropts -o qmaill -g 0
	keepdir /var/log/qmail/${1}
	)
}

qmail_supervise_install() {
	einfo "Installing supervise scripts"

	cd "${GENQMAIL_S}"/supervise || die

	local i
	for i in qmail-{send,smtpd,qmtpd,qmqpd}; do
		qmail_supervise_install_one ${i}
	done

	if use pop3; then
		qmail_supervise_install_one qmail-pop3d
	fi
}

qmail_spp_install() {
	einfo "Installing qmail-spp configuration files"
	insinto "${QMAIL_HOME}"/control/
	doins "${GENQMAIL_S}"/spp/smtpplugins

	einfo "Installing qmail-spp plugins"
	keepdir "${QMAIL_HOME}"/plugins/
	local i
	for i in authlog mfdnscheck ifauthnext tarpit; do
		dospp "${GENQMAIL_S}"/spp/${i}
	done
}

qmail_ssl_install() {
	use gencertdaily && \
		CRON_FOLDER=cron.daily || \
		CRON_FOLDER=cron.hourly

	einfo "Installing SSL Certificate creation script"
	insinto "${QMAIL_HOME}"/control
	doins "${GENQMAIL_S}"/ssl/servercert.cnf

	exeinto "${QMAIL_HOME}"/bin
	doexe "${GENQMAIL_S}"/ssl/mkservercert

	einfo "Installing RSA key generation cronjob"
	exeinto /etc/${CRON_FOLDER}
	doexe "${GENQMAIL_S}"/ssl/qmail-genrsacert.sh

	keepdir "${QMAIL_HOME}"/control/tlshosts
}

qmail_src_install() {
	qmail_base_install
	qmail_config_install
	qmail_man_install
	qmail_sendmail_install
	qmail_maildir_install
	qmail_tcprules_install
	qmail_supervise_install

	use qmail-spp && qmail_spp_install
	use ssl && qmail_ssl_install
}

qmail_queue_setup() {
	if use highvolume; then
		myconf="--bigtodo"
	else
		myconf="--no-bigtodo"
	fi

	mysplit=${QMAIL_CONF_SPLIT:-23}
	is_prime ${mysplit} || die "QMAIL_CONF_SPLIT is not a prime number."

	einfo "Setting up the message queue hierarchy"
	/usr/bin/queue-repair.py --create ${myconf} \
		--split ${mysplit} \
		"${ROOT}${QMAIL_HOME}" >/dev/null || \
		die 'queue-repair failed'
}

qmail_rootmail_fixup() {
	local TMPCMD="ln -sf ${QMAIL_HOME}/alias/.maildir/ ${ROOT}/root/.maildir"

	if [[ -d ${ROOT}/root/.maildir && ! -L ${ROOT}/root/.maildir ]] ; then
		elog "Previously the qmail ebuilds created /root/.maildir/ but not"
		elog "every mail was delivered there. If the directory does not"
		elog "contain any mail, please delete it and run:"
		elog "${TMPCMD}"
	else
		${TMPCMD}
	fi

	chown -R alias:qmail "${ROOT}${QMAIL_HOME}"/alias/.maildir 2>/dev/null
}

qmail_tcprules_build() {
	local f
	for f in tcp.qmail-{smtp,qmtp,qmqp,pop3}; do
		# please note that we don't check if it exists
		# as we want it to make the cdb files anyway!
		local src="${ROOT}${TCPRULES_DIR}/${f}"
		local cdb="${ROOT}${TCPRULES_DIR}/${f}.cdb"
		local tmp="${ROOT}${TCPRULES_DIR}/.${f}.tmp"
		[[ -e ${src} ]] && tcprules "${cdb}" "${tmp}" < "${src}"
	done
}

qmail_config_notice() {
	elog
	elog "To setup ${PN} to run out-of-the-box on your system, run:"
	elog "emerge --config =${CATEGORY}/${PF}"
}

qmail_supervise_config_notice() {
	elog
	elog "To start qmail at boot you have to add svscan to your startup"
	elog "and create the following links:"
	elog "ln -s ${SUPERVISE_DIR}/qmail-send /service/qmail-send"
	elog "ln -s ${SUPERVISE_DIR}/qmail-smtpd /service/qmail-smtpd"
	elog
	if use pop3; then
		elog "To start the pop3 server as well, create the following link:"
		elog "ln -s ${SUPERVISE_DIR}/qmail-pop3d /service/qmail-pop3d"
		elog
	fi
	elog "Additionally, the QMTP and QMQP protocols are supported, "
	elog "and can be started as:"
	elog "ln -s ${SUPERVISE_DIR}/qmail-qmtpd /service/qmail-qmtpd"
	elog "ln -s ${SUPERVISE_DIR}/qmail-qmqpd /service/qmail-qmqpd"
	elog
	elog "Additionally, if you wish to run qmail right now, you should "
	elog "run this before anything else:"
	elog "source /etc/profile"
}

qmail_config_fast() {
	if [[ -z ${ROOT} ]]; then
		local host=$(hostname --fqdn)

		if [[ -z ${host} ]]; then
			eerror
			eerror "Cannot determine your fully-qualified hostname"
			eerror "Please setup your /etc/hosts as described in"
			eerror "https://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=1&chap=8#doc_chap2_sect4"
			eerror
			die "cannot determine FQDN"
		fi

		if [[ ! -f ${ROOT}${QMAIL_HOME}/control/me ]]; then
			"${ROOT}${QMAIL_HOME}"/bin/config-fast ${host}
		fi
	else
		ewarn "Skipping some configuration as it MUST be run on the final host"
	fi
}

qmail_tcprules_config() {
	local localips ip tcpstring proto f

	einfo "Accepting relaying by default from all ips configured on this machine."

	# Start with iproute2 as ifconfig is deprecated, and ifconfig does not handle
	# additional addresses added via iproute2.
	# Note: We have to strip off the packed netmask w/e.g. 192.168.0.2/24
	localips=$(ip address show 2>/dev/null | awk '$1 == "inet" {print $2}' | sed 's:/.*::')
	if [[ -z ${localips} ]] ; then
		# Hello old friend.  Maybe you can tell us at least something.
		localips=$(ifconfig | awk '$1 == "inet" {print $2}')
	fi

	tcpstring=':allow,RELAYCLIENT="",RBLSMTPD=""'

	for ip in ${localips}; do
		for proto in smtp qmtp qmqp; do
			f="${EROOT}${TCPRULES_DIR}/tcp.qmail-${proto}"
			grep -qs "^${ip}:" "${f}" || echo "${ip}${tcpstring}" >> "${f}"
		done
	done
}

qmail_ssl_generate() {
	CRON_FOLDER=cron.hourly
	use gencertdaily && CRON_FOLDER=cron.daily

	ebegin "Generating RSA keys for SSL/TLS, this can take some time"
	"${ROOT}"/etc/${CRON_FOLDER}/qmail-genrsacert.sh
	eend $?

	einfo "Creating a self-signed ssl-certificate:"
	"${ROOT}${QMAIL_HOME}"/bin/mkservercert

	einfo "If you want to have a properly signed certificate "
	einfo "instead, do the following:"
	# space at the end of the string because of the current implementation
	# of einfo
	einfo "openssl req -new -nodes -out req.pem \\ "
	einfo "  -config ${QMAIL_HOME}/control/servercert.cnf \\ "
	einfo "  -keyout ${QMAIL_HOME}/control/servercert.pem"
	einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
	einfo "cat signed_req.pem >> ${QMAIL_HOME}/control/servercert.pem"
}

fi
