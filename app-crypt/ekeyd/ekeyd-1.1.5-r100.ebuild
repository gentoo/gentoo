# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit linux-info lua-single systemd toolchain-funcs udev

DESCRIPTION="Entropy Key userspace daemon"
HOMEPAGE="http://www.entropykey.co.uk/"
SRC_URI="mirror://ubuntu/pool/universe/e/ekeyd/ekeyd_${PV}.orig.tar.gz"

LICENSE="MIT GPL-2" # GPL-2 (only) for init script
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kernel_linux munin minimal usb"

REQUIRED_USE="${LUA_REQUIRED_USE}
	minimal? ( !munin )"

EKEYD_RDEPEND="${LUA_DEPS}"
EKEYD_DEPEND="${EKEYD_RDEPEND}"
EKEYD_RDEPEND="${EKEYD_RDEPEND}
	$(lua_gen_cond_dep '
		dev-lua/luasocket[${LUA_USEDEP}]
	')
	kernel_linux? ( virtual/udev )
	munin? ( net-analyzer/munin )"

RDEPEND="!minimal? ( ${EKEYD_RDEPEND} )
	virtual/service-manager"
DEPEND="!minimal? ( ${EKEYD_DEPEND} )"

CONFIG_CHECK="~USB_ACM"

pkg_setup() {
	if ! use minimal && use kernel_linux && ! use usb && linux_config_exists; then
		check_extra_config
	fi
	lua-single_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-const_char_usage.patch
	"${FILESDIR}"/${P}-enoent.patch
	"${FILESDIR}"/${P}-path-fixes.patch
	"${FILESDIR}"/${P}-udev-rule.patch
	"${FILESDIR}"/${P}-remove-werror.patch
	"${FILESDIR}"/${P}-misc.patch
	"${FILESDIR}"/${P}-makefile-lua-libs.patch
)

src_compile() {
	local osname

	# Override automatic detection: upstream provides this with uname,
	# we don't like using uname.
	case ${CHOST} in
		*-linux-*)
			osname=linux;;
		*-freebsd*)
			osname=freebsd;;
		*-kfrebsd-gnu)
			osname=gnukfreebsd;;
		*-openbsd*)
			osname=openbsd;;
		*)
			die "Unsupported operating system!"
			;;
	esac

	emake -C host \
		CC="$(tc-getCC)" \
		LUA_V=${ELUA#lua} \
		LUA_INC="-I$(lua_get_include_dir)" \
		OSNAME=${osname} \
		OPT="${CFLAGS}" \
		BUILD_ULUSBD=no \
		$(use minimal && echo egd-linux)
}

src_install() {
	exeinto /usr/libexec
	newexe host/egd-linux   ekey-egd-linux
	newman host/egd-linux.8 ekey-egd-linux.8

	newconfd "${FILESDIR}"/ekey-egd-linux.conf.2 ekey-egd-linux
	newinitd "${FILESDIR}"/ekey-egd-linux.init.2 ekey-egd-linux

	dodoc doc/* AUTHORS ChangeLog THANKS

	use minimal && return
	# from here on, install everything that is not part of the minimal
	# support.

	emake -C host \
		DESTDIR="${D}" \
		MANZCMD=cat MANZEXT= \
		install-ekeyd

	# We move the daemons around to avoid polluting the available
	# commands.
	dodir /usr/libexec
	mv "${D}"/usr/sbin/ekey*d "${D}"/usr/libexec

	systemd_dounit "${FILESDIR}/ekeyd.service"

	newinitd "${FILESDIR}"/${PN}.init.2 ${PN}

	if use kernel_linux; then
		local rules="${FILESDIR}/90-ekeyd.rules"
		udev_newrules ${rules} 90-${PN}.rules
	fi

	if use munin; then
		exeinto /usr/libexec/munin/plugins
		doexe munin/ekeyd_stat_

		insinto /etc/munin/plugin-conf.d
		newins munin/plugin-conf.d_ekeyd ekeyd
	fi
}

pkg_postinst() {
	elog "${CATEGORY}/${PN} now install also the EGD client service ekey-egd-linux."
	elog "To use this service, you need enable EGDTCPSocket for the ekeyd service"
	elog "managing the key(s)."
	elog ""
	elog "The daemon will send more entropy to the kernel once the available pool"
	elog "falls below the value set in the kernel.random.write_wakeup_threshold"
	elog "sysctl entry."
	elog ""
	ewarn "Since version 1.1.4-r1, ekey-egd-linux will *not* set the watermark for"
	ewarn "you, instead you'll have to configure the sysctl in /etc/sysctl.conf"

	use minimal && return
	# from here on, document everything that is not part of the minimal
	# support.

	elog ""
	elog "To make use of your EntropyKey, make sure to execute ekey-rekey"
	elog "the first time, and then start the ekeyd service."
	elog ""
	elog "By default ekeyd will feed the entropy directly to the kernel's pool;"
	elog "if your system has jumps in load average, you might prefer using the"
	elog "EGD compatibility mode, by enabling EGDTCPSocket for ekeyd and then"
	elog "starting the ekey-egd-linux service."
	elog ""
	elog "The same applies if you intend to provide entropy for multiple hosts"
	elog "over the network. If you want to have the ekey-egd-linux service on"
	elog "other hosts, you can enable the 'minimal' USE flag."
	elog ""
	elog "The service supports multiplexing if you wish to use multiple"
	elog "keys, just symlink /etc/init.d/ekeyd -> /etc/init.d/ekeyd.identifier"
	elog "and it'll be looking for /etc/entropykey/identifier.conf"
	elog ""

		if use kernel_linux; then
			elog "Some versions of Linux have a faulty CDC ACM driver that stops"
			elog "EntropyKey from working properly; please check the compatibility"
			elog "table at http://www.entropykey.co.uk/download/"
		else
			elog "Make sure your operating system supports the CDC ACM driver"
			elog "or otherwise you won't be able to use the EntropyKey."
		fi
		elog ""
		elog "If you're unsure about the working state of the CDC ACM driver"
		elog "enable the usb USE flag and use the userland USB daemon"
}
