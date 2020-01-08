# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
PYTHON_REQ_USE="ncurses(+)"

inherit distutils-r1 linux-info

DESCRIPTION="Top-like UI used to show which process is using the I/O"
HOMEPAGE="http://guichaz.free.fr/iotop/"
SRC_URI="http://guichaz.free.fr/iotop/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS ~VM_EVENT_COUNTERS"

DOCS=( NEWS README THANKS ChangeLog )

PATCHES=(
	"${FILESDIR}"/${P}-setup.py3.patch
	"${FILESDIR}"/${P}-Only-split-proc-status-lines-on-the-character.patch
	"${FILESDIR}"/${P}-Ignore-invalid-lines-in-proc-status-files.patch
	"${FILESDIR}"/${P}-Actually-skip-invalid-lines-in-proc-status.patch
)

pkg_setup() {
	linux-info_pkg_setup
}
