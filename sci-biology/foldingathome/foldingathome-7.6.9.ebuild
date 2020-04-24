# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user systemd

DESCRIPTION="Folding@Home is a distributed computing project for protein folding"
HOMEPAGE="https://foldingathome.org/"
SRC_URI="https://download.foldingathome.org/releases/public/release/fahclient/centos-6.7-64bit/v$(ver_cut 1-2)/fahclient_${PV}-64bit-release.tar.bz2"

RESTRICT="mirror bindist strip"

LICENSE="FAH-EULA-2014 FAH-special-permission"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
# Expressly listing all deps, as this is a binpkg and it is doubtful whether
# i.e. uclibc or clang can provide what is necessary at runtime
DEPEND="dev-util/patchelf"
RDEPEND="app-arch/bzip2
	|| (
		dev-libs/openssl-compat:1.0.0
		=dev-libs/openssl-1.0*:*
	)
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib
	acct-group/video
"

S="${WORKDIR}/fahclient_${PV}-64bit-release"

QA_PREBUILT="opt/foldingathome/*"

pkg_setup() {
	elog ""
	elog "Special permission is hereby granted to the Gentoo project to provide an"
	elog "automated installer package which downloads and installs the Folding@home client"
	elog "software. Permission is also granted for future Gentoo installer packages on the"
	elog "condition that they continue to adhere to all of the terms of the accompanying"
	elog "Folding@home license agreements and display this notice."
	elog "-- Vijay S. Pande, Stanford University, 07 May 2013"
	elog ""
	elog "(ref: http://foldingforum.org/viewtopic.php?f=16&t=22524&p=241992#p241992 )"
	elog ""

	enewgroup foldingathome
	enewuser foldingathome -1 -1 "${EPREFIX}"/opt/foldingathome video
}

src_install() {
	patchelf --set-rpath "${EPREFIX}/opt/foldingathome" FAHClient || die
	patchelf --set-rpath "${EPREFIX}/opt/foldingathome" FAHCoreWrapper || die

	dosym "../../usr/$(get_libdir)/libssl.so.1.0.0" /opt/foldingathome/libssl.so.10
	dosym "../../usr/$(get_libdir)/libcrypto.so.1.0.0" /opt/foldingathome/libcrypto.so.10

	exeinto /opt/foldingathome
	doexe {FAHClient,FAHCoreWrapper}

	insinto /opt/foldingathome
	doins sample-config.xml

	newconfd "${FILESDIR}"/7.3/folding-conf.d foldingathome
	cat <<EOF >"${T}"/fah-init
#!/sbin/openrc-run
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

start_stop_daemon_args="--chdir \"${EPREFIX}/opt/foldingathome\""
command="${EPREFIX}/opt/foldingathome/FAHClient"
command_args="\${FOLD_OPTS}"
command_user=foldingathome
command_background=1
pidfile="\${PIDFILE}"
EOF
	newinitd "${T}"/fah-init foldingathome

	cat <<EOF >"${T}"/fah-init.service
[Unit]
Description=Folding@Home V7 Client
Documentation=https://foldingathome.org

[Service]
Type=simple
User=foldingathome
Group=foldingathome
Nice=19
WorkingDirectory=${EPREFIX}/opt/foldingathome
ExecStart=${EPREFIX}/opt/foldingathome/FAHClient --fork=false --pid=false --respawn=false --service=false
NoNewPrivileges=yes
PrivateTmp=yes
ProtectControlGroups=yes
ProtectSystem=full
RestrictRealtime=true
ProtectControlGroups=yes

[Install]
WantedBy=multi-user.target
EOF
	systemd_newunit "${T}"/fah-init.service foldingathome.service

	fowners -R foldingathome:foldingathome /opt/foldingathome
}

pkg_postinst() {
	elog "To run Folding@home in the background at boot:"
	elog "(openrc)\trc-update add foldingathome default"
	elog "(systemd)\tsystemctl enable foldingathome"
	elog ""
	if [ ! -e "${EPREFIX}"/opt/foldingathome/config.xml ]; then
		elog "No config.xml file found -- please run"
		elog "emerge --config ${P} to configure your client, or specify"
		elog "all necessary runtime options in FOLD_OPTS within"
		elog "${EPREFIX}/etc/conf.d/foldingathome"
		elog ""
	fi
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "NOTE, the 'initfolding' helper script has been dropped, please"
		elog "use emerge --config ${P} or run FAHClient --configure directly"
		elog "and adjust file permissions and ownership yourself"
		elog ""
	fi
	elog "Please see ${EPREFIX}/opt/foldingathome/FAHClient --help for more details."
	einfo ""
	einfo "The original package maintainer encourages you to acquire a username and join team 36480."
	einfo "http://folding.stanford.edu/English/Download#ntoc2"
	einfo ""
}

pkg_postrm() {
	elog "Folding@home data files were not removed."
	elog "Remove them manually from ${EPREFIX}/opt/foldingathome"
}

pkg_config() {
	cd "${EPREFIX}"/opt/foldingathome || die
	su foldingathome -s /bin/sh -c "./FAHClient --configure"
}
