# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION="2.8.2"

inherit cmake-utils eutils systemd user

DESCRIPTION="Advanced and secure webserver"
HOMEPAGE="http://www.hiawatha-webserver.org"
SRC_URI="http://www.hiawatha-webserver.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cache ipv6 monitor +rewrite +rproxy +ssl tomahawk +xslt"

RDEPEND="
	sys-libs/zlib
	ssl? ( >=net-libs/mbedtls-2.0[threads] )
	xslt? (	dev-libs/libxslt
			dev-libs/libxml2 )"
DEPEND="${RDEPEND}"
PDEPEND="monitor? ( www-apps/hiawatha-monitor )"

# set these in the environment of your PM if you want to use different values
HIAWATHA_CONFIG_DIR="${HIAWATHA_CONFIG_DIR:-/etc/hiawatha}"
HIAWATHA_LOG_DIR="${HIAWATHA_LOG_DIR:-/var/log/hiawatha}"
HIAWATHA_PID_DIR="${HIAWATHA_PID_DIR:-/var/run}"
HIAWATHA_WEBROOT_DIR="${HIAWATHA_WEBROOT_DIR:-/var/www/hiawatha}"
HIAWATHA_WORK_DIR="${HIAWATHA_WORK_DIR:-/var/lib/hiawatha}"
HIAWATHA_USER="${HIAWATHA_USER:-hiawatha}"
HIAWATHA_GROUP="${HIAWATHA_GROUP:-hiawatha}"

safe_sed() {
	local replace_of=$1
	local replace_with=$2
	local file=$3
	# optional
	local outfile=$4

	grep -E "${replace_of}" "${file}" 1>/dev/null \
		|| die "\"${replace_of}\" not found in ${file}!"

	if [[ -n ${outfile} ]] ; then
		einfo "Sedding ${file} into ${outfile}"
		sed -r \
			-e "s|${replace_of}|${replace_with}|" \
			"${file}" > ${outfile} || die "sed on ${file} to ${outfile} failed!"
	else
		einfo "Sedding ${file} in-place"
		sed -r -i \
			-e "s|${replace_of}|${replace_with}|" \
			"${file}" || die "sed on ${file} failed!"
	fi

}

pkg_pretend() {
	einfo
	einfo "You can change hiawatha user and group, as well as the"
	einfo "directories the webserver is going to use. For that,"
	einfo "set the following environment variables in your PM:"
	einfo "  HIAWATHA_CONFIG_DIR"
	einfo "    default: /etc/hiawatha"
	einfo "    current: ${HIAWATHA_CONFIG_DIR}"
	einfo "  HIAWATHA_LOG_DIR"
	einfo "    default: /var/log/hiawatha"
	einfo "    current: ${HIAWATHA_LOG_DIR}"
	einfo "  HIAWATHA_PID_DIR"
	einfo "    default: /var/run"
	einfo "    current: ${HIAWATHA_PID_DIR}"
	einfo "  HIAWATHA_WEBROOT_DIR"
	einfo "    default: /var/www/hiawatha"
	einfo "    current: ${HIAWATHA_WEBROOT_DIR}"
	einfo "  HIAWATHA_WORK_DIR"
	einfo "    default: /var/lib/hiawatha"
	einfo "    current: ${HIAWATHA_WORK_DIR}"
	einfo "  HIAWATHA_USER"
	einfo "    default: hiawatha"
	einfo "    current: ${HIAWATHA_USER}"
	einfo "  HIAWATHA_GROUP"
	einfo "    default: hiawatha"
	einfo "    current: ${HIAWATHA_GROUP}"
	einfo
}

pkg_setup() {
	enewgroup ${HIAWATHA_GROUP}
	enewuser ${HIAWATHA_USER} -1 -1 "${HIAWATHA_WEBROOT_DIR}" ${HIAWATHA_GROUP}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-9.5-cflags.patch

	safe_sed "^#ServerId =.*$" "ServerId = ${HIAWATHA_USER}" \
		config/hiawatha.conf.in

	safe_sed "@HIAWATHA_PID_DIR@" "${HIAWATHA_PID_DIR}" \
		"${FILESDIR}/hiawatha.initd-r1" \
		"${T}/hiawatha.initd-r1"
}

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DIR:STRING="${HIAWATHA_CONFIG_DIR}"
		-DENABLE_CACHE=$(usex cache)
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_LOADCHECK=$(usex kernel_linux)
		-DENABLE_MONITOR=$(usex monitor)
		-DENABLE_RPROXY=$(usex rproxy)
		-DENABLE_TLS=$(usex ssl)
		-DENABLE_TOMAHAWK=$(usex tomahawk)
		-DENABLE_TOOLKIT=$(usex rewrite)
		-DENABLE_XSLT=$(usex xslt)
		-DLOG_DIR:STRING="${HIAWATHA_LOG_DIR}"
		-DPID_DIR:STRING="${HIAWATHA_PID_DIR}"
		-DUSE_SYSTEM_MBEDTLS=$(usex ssl)
		-DWEBROOT_DIR:STRING="${HIAWATHA_WEBROOT_DIR}"
		-DWORK_DIR:STRING="${HIAWATHA_WORK_DIR}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -r "${ED%/}${HIAWATHA_WEBROOT_DIR}"/* || die

	newinitd "${T}"/hiawatha.initd-r1 hiawatha
	systemd_dounit "${FILESDIR}"/hiawatha.service

	local i
	for i in "${HIAWATHA_LOG_DIR}" "${HIAWATHA_WORK_DIR}" ; do
		keepdir "${i}"
		fowners ${HIAWATHA_USER}:${HIAWATHA_GROUP} "${i}"
		fperms 0750 "${i}"
	done

	keepdir "${HIAWATHA_WEBROOT_DIR}"
	fowners ${HIAWATHA_USER}:${HIAWATHA_GROUP} "${HIAWATHA_WEBROOT_DIR}"
}
