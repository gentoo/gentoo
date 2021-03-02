# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Dell Inspiron and Latitude utilities"
HOMEPAGE="https://launchpad.net/i8kutils"
SRC_URI="https://launchpad.net/i8kutils/trunk/${PV}/+download/${P/-/_}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/tcl
	sys-power/acpi
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

pkg_pretend() {
	# Check for required dell-smm-hwmon (formerly i8k) driver
	if ! linux_config_exists; then
		eerror "Unable to check your kernel for dell-smm-hwmon (i8k) support"
	else
		CONFIG_CHECK="~I8K"
		ERROR_I8K="You must have the dell_smm_hwmon driver compiled into your"
		ERROR_I8K+=" kernel or loaded as a module to use i8kutils' utilities"
		check_extra_config
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin i8k{ctl,fan,mon}
	doman i8k{ctl,mon}.1
	newdoc README.i8kutils README
	insinto /etc
	doins i8kmon.conf

	newinitd "${FILESDIR}/i8kmon.init" i8kmon
	systemd_dounit debian/i8kmon.service
}
