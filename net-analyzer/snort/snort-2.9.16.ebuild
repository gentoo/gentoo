# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools user systemd tmpfiles

DESCRIPTION="The de facto standard for intrusion detection/prevention"
HOMEPAGE="https://www.snort.org"
SRC_URI="https://www.snort.org/downloads/archive/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+active-response control-socket debug file-inspect +flexresp3 +gre
high-availability inline-init-failopen large-pcap-64bit +libtirpc
linux-smp-stats +non-ether-decoders open-appid +perfprofiling +ppm +react
reload-error-restart selinux shared-rep side-channel sourcefire static
+threads"

DEPEND=">=net-libs/libpcap-1.3.0
	>=net-libs/daq-2.0.2
	>=dev-libs/libpcre-8.33
	dev-libs/libdnet
	net-libs/libnsl:0=
	sys-libs/zlib
	!libtirpc? ( sys-libs/glibc[rpc(-)] )
	libtirpc? ( net-libs/libtirpc )
	open-appid? ( dev-lang/luajit:= )
"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-snort )"

REQUIRED_USE="!kernel_linux? ( !shared-rep )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.8.3-no-implicit.patch
	"${FILESDIR}"/${PN}-2.9.8.3-rpc.patch
	"${FILESDIR}"/${PN}-2.9.12-snort.pc.patch
	"${FILESDIR}"/${PN}-2.9.15.1-fno-common.patch
)

pkg_setup() {
	# pre_inst() is a better place to put this
	# but we need it here for the 'fowners' statements in src_install()
	enewgroup snort
	enewuser snort -1 -1 /dev/null snort

}

src_prepare() {
	default

	mv configure.{in,ac} || die

	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	econf \
		$(use_enable !static shared) \
		$(use_enable static) \
		$(use_enable static so-with-static-lib) \
		$(use_enable gre) \
		$(use_enable control-socket) \
		$(use_enable file-inspect) \
		$(use_enable high-availability ha) \
		$(use_enable non-ether-decoders) \
		$(use_enable shared-rep) \
		$(use_enable side-channel) \
		$(use_enable sourcefire) \
		$(use_enable ppm) \
		$(use_enable perfprofiling) \
		$(use_enable linux-smp-stats) \
		$(use_enable inline-init-failopen) \
		$(use_enable open-appid) \
		$(use_enable threads pthread) \
		$(use_enable debug) \
		$(use_enable debug debug-msgs) \
		$(use_enable debug corefiles) \
		$(use_enable !debug dlclose) \
		$(use_enable active-response) \
		$(use_enable reload-error-restart) \
		$(use_enable react) \
		$(use_enable flexresp3) \
		$(use_enable large-pcap-64bit large-pcap) \
		$(use_with libtirpc) \
		--enable-mpls \
		--enable-normalizer \
		--enable-reload \
		--enable-targetbased \
		--disable-build-dynamic-examples \
		--disable-profile \
		--disable-ppm-test \
		--disable-intel-soft-cpm \
		--disable-static-daq
}

src_install() {
	default

	keepdir /var/log/snort \
		/etc/snort/rules \
		/etc/snort/so_rules \
		/usr/$(get_libdir)/snort_dynamicrules

	# config.log and build.log are needed by Sourcefire
	# to trouble shoot build problems and bug reports so we are
	# perserving them incase the user needs upstream support.
	dodoc RELEASE.NOTES ChangeLog \
		doc/* \
		tools/u2boat/README.u2boat

	insinto /etc/snort
	doins etc/attribute_table.dtd \
		etc/classification.config \
		etc/gen-msg.map \
		etc/reference.config \
		etc/threshold.conf \
		etc/unicode.map

	# We use snort.conf.distrib because the config file is complicated
	# and the one shipped with snort can change drastically between versions.
	# Users should migrate setting by hand and not with etc-update.
	newins etc/snort.conf snort.conf.distrib

	# config.log and build.log are needed by Sourcefire
	# to troubleshoot build problems and bug reports so we are
	# preserving them incase the user needs upstream support.
	if [ -f "${WORKDIR}/${PF}/config.log" ]; then
		dodoc "${WORKDIR}/${PF}/config.log"
	fi
	if [ -f "${T}/build.log" ]; then
		dodoc "${T}/build.log"
	fi

	insinto /etc/snort/preproc_rules
	doins preproc_rules/decoder.rules \
		preproc_rules/preprocessor.rules \
		preproc_rules/sensitive-data.rules

	fowners -R snort:snort \
		/var/log/snort \
		/etc/snort

	newinitd "${FILESDIR}/snort.rc12" snort
	newconfd "${FILESDIR}/snort.confd.2" snort
	systemd_newunit "${FILESDIR}/snort_at.service" "snort@.service"

	newtmpfiles "${FILESDIR}"/snort.tmpfiles snort.conf

	# Sourcefire uses Makefiles to install docs causing Bug #297190.
	# This removes the unwanted doc directory and rogue Makefiles.
	rm -rf "${ED}"/usr/share/doc/snort || die "Failed to remove SF doc directories"
	rm "${ED}"/usr/share/doc/"${PF}"/Makefile* || die "Failed to remove doc make files"

	# Remove unneeded .la files (Bug #382863)
	rm -f "${ED}"/usr/$(get_libdir)/snort_dynamicengine/libsf_engine.la || die
	rm -f "${ED}"/usr/$(get_libdir)/snort_dynamicpreprocessor/libsf_*_preproc.la || die "Failed to remove libsf_?_preproc.la"

	# Set the correct lib path for dynamicengine, dynamicpreprocessor, and dynamicdetection
	sed -i -e 's|/usr/local/lib|/usr/'$(get_libdir)'|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Set the correct rule location in the config
	sed -i -e 's|RULE_PATH ../rules|RULE_PATH /etc/snort/rules|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Set the correct preprocessor/decoder rule location in the config
	sed -i -e 's|PREPROC_RULE_PATH ../preproc_rules|PREPROC_RULE_PATH /etc/snort/preproc_rules|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Enable the preprocessor/decoder rules
	sed -i -e 's|^# include $PREPROC_RULE_PATH|include $PREPROC_RULE_PATH|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	sed -i -e 's|^# dynamicdetection directory|dynamicdetection directory|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Just some clean up of trailing /'s in the config
	sed -i -e 's|snort_dynamicpreprocessor/$|snort_dynamicpreprocessor|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Make it clear in the config where these are...
	sed -i -e 's|^include classification.config|include /etc/snort/classification.config|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	sed -i -e 's|^include reference.config|include /etc/snort/reference.config|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Disable all rule files by default.
	sed -i -e 's|^include $RULE_PATH|# include $RULE_PATH|g' \
		"${ED%}/etc/snort/snort.conf.distrib" || die

	# Set the configured DAQ to afpacket
	sed -i -e 's|^# config daq: <type>|config daq: afpacket|g' \
		"${ED%}/etc/snort/snort.conf.distrib" || die

	# Set the location of the DAQ modules
	sed -i -e 's|^# config daq_dir: <dir>|config daq_dir: /usr/'$(get_libdir)'/daq|g' \
		"${ED%}/etc/snort/snort.conf.distrib" || die

	# Set the DAQ mode to passive
	sed -i -e 's|^# config daq_mode: <mode>|config daq_mode: passive|g' \
		"${ED%}/etc/snort/snort.conf.distrib" || die

	# Set snort to run as snort:snort
	sed -i -e 's|^# config set_gid:|config set_gid: snort|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die
	sed -i -e 's|^# config set_uid:|config set_uid: snort|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Set the default log dir
	sed -i -e 's|^# config logdir:|config logdir: /var/log/snort/|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die

	# Set the correct so_rule location in the config
	sed -i -e 's|SO_RULE_PATH ../so_rules|SO_RULE_PATH /etc/snort/so_rules|g' \
		"${ED}/etc/snort/snort.conf.distrib" || die
}

pkg_postinst() {
	tmpfiles_process snort.conf

	einfo "There have been a number of improvements and new features"
	einfo "added to ${P}. Please review the RELEASE.NOTES and"
	einfo "ChangLog located in /usr/share/doc/${PF}."
	einfo
	elog "The Sourcefire Vulnerability Research Team (VRT) recommends that"
	elog "users migrate their snort.conf customizations to the latest config"
	elog "file released by the VRT. You can find the latest version of the"
	elog "Snort config file in /etc/snort/snort.conf.distrib."
	elog
	elog "!! It is important that you migrate to this new snort.conf file !!"
	elog
	elog "This version of the ebuild includes an updated init.d file and"
	elog "conf.d file that rely on options found in the latest Snort"
	elog "config file provided by the VRT."

	if use debug; then
		elog "You have the 'debug' USE flag enabled. If this has been done to"
		elog "troubleshoot an issue by producing a core dump or a back trace,"
		elog "then you need to also ensure the FEATURES variable in make.conf"
		elog "contains the 'nostrip' option."
	fi
}
