# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="ncurses(+)"

MY_COMMIT="a14256a3ff74eeee59493ac088561f1bafab85a7"
inherit distutils-r1 linux-info

DESCRIPTION="Top-like UI used to show which process is using the I/O"
HOMEPAGE="http://guichaz.free.fr/iotop/"
SRC_URI="https://repo.or.cz/iotop.git/snapshot/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT::7}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="!sys-process/iotop-c"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS ~VM_EVENT_COUNTERS"

DOCS=( NEWS README THANKS )

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

pkg_postinst() {
	ewarn "Since Linux 5.14, sysctl kernel.task_delayacct should be enabled"
	ewarn "This can be enabled by running: 'sysctl kernel.task_delayacct=1' "
	ewarn "And can be made persistent by adding 'kernel.task_delayacct = 1' to ${EROOT}/etc/sysctl.conf"
}
