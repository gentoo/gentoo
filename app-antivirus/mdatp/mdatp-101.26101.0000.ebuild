# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There is no way to control which Python version this uses, so there is no
# point in using the Python eclasses. It is published for a variety of
# distribution releases, old and new, so any recent version will probably work.

RPM_COMPRESS_TYPE="none"
inherit linux-info rpm shell-completion systemd

DESCRIPTION="Microsoft Defender Advanced Threat Protection for Endpoints"
HOMEPAGE="https://learn.microsoft.com/defender-endpoint/microsoft-defender-endpoint-linux"
SRC_URI="https://packages.microsoft.com/fedora/44/prod/Packages/${PN:0:1}/${P}-1.x86_64.rpm"
S="${WORKDIR}"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="selinux"
RESTRICT="bindist mirror strip"

RDEPEND="
	acct-user/mdatp
	>=dev-lang/python-3.11
	dev-libs/glib:2
	dev-libs/libffi:0/8
	dev-libs/libpcre2:0/3
	|| (
		dev-libs/openssl-compat:3
		dev-libs/openssl:0/3
	)
	net-libs/libmnl:0/0.2.0
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	net-misc/curl
	sys-apps/acl
	sys-apps/util-linux
	sys-libs/libseccomp
	sys-libs/libselinux
	virtual/zlib:0/1
"
IDEPEND="
	selinux? ( sys-apps/policycoreutils )
"

QA_PREBUILT="*"

LOG_DIR="var/log/microsoft/${PN}"
OPT_DIR="opt/microsoft/${PN}"
VAR_DIR="var/opt/microsoft/${PN}"

pkg_setup() {
	local CONFIG_CHECK="~BPF_SYSCALL"
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Don't install these files under /opt.
	mv -v "${OPT_DIR}"/conf/*.{service,socket} "${OPT_DIR}"/resources/ . || die

	# Drop non-Gentoo files.
	rm -v "${OPT_DIR}"/conf/selinux_policies/out/audisp_mdatp_rhel77.pp || die

	# Drop the client analyzer diagnostic tool. It bundles libpython (ugh) and
	# upstream probably doesn't want reports from Gentoo users anyway.
	rm -rv "${OPT_DIR}"/tools/client_analyzer/ || die

	# Unbundle libraries where possible. Don't unbundle C++ libraries because
	# they are probably built against libc++ rather than libstdc++.
	cd "${OPT_DIR}"/lib || die
	rm -v \
		libatomic.so.1 \
		libcrypto.so.3 \
		libcurl.so.4 \
		libffi.so.8.* \
		libglib-2.0.so.0.* \
		libmnl.so.0.* \
		libnetfilter_queue.so.1.* \
		libnfnetlink.so.0.* \
		libpcre2-8.so \
		libpcre2-posix.so.3.* \
		libseccomp.so.2 \
		libselinux.so.1 \
		libssl.so.3 \
		libuuid.so.1 \
		libz.so.1.* \
		|| die
}

src_install() {
	insinto "/${OPT_DIR%/*}"
	doins -r "${OPT_DIR}"
	fperms -R +x "${OPT_DIR}"/{lib,sbin}/ $(find "${OPT_DIR}" -type f -executable)
	dosym -r "/${OPT_DIR}"/sbin/wdavdaemonclient /usr/bin/${PN}

	systemd_dounit *.{service,socket}
	newbashcomp resources/${PN}_completion.bash ${PN}
	newzshcomp resources/${PN}_completion.zsh _${PN}

	keepdir "/${LOG_DIR}" "/${VAR_DIR}"
}

# Upgrading while the service is running can apparently potentially cause
# corruption, so mask and stop before, then unmask and restart afterwards.

pkg_preinst() {
	if [[ -z ${ROOT} ]] && systemd_is_booted; then
		WAS_ACTIVE=$(systemctl is-active ${PN}.service)
		systemctl mask --now ${PN}.service
	fi
}

pkg_postrm() {
	if use selinux; then
		semodule ${ROOT:+-p "${ROOT}" -n} -r mdatp_service
	fi
}

pkg_postinst() {
	if use selinux; then
		semodule ${ROOT:+-p "${ROOT}" -n} -i "${EROOT}/${OPT_DIR}"/conf/selinux_policies/out/mdatp_service.pp
	fi

	if [[ -z ${ROOT} ]] && systemd_is_booted; then
		systemctl unmask ${PN}.service
		[[ ${WAS_ACTIVE} == active ]] && systemctl start ${PN}.service
	fi
}
