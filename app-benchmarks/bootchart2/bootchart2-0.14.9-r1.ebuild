# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit linux-info python-single-r1 systemd toolchain-funcs

DESCRIPTION="Performance analysis and visualization of the system boot process"
HOMEPAGE="https://github.com/xrmx/bootchart"
SRC_URI="https://github.com/xrmx/bootchart/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN%2}-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+cairo"

REQUIRED_USE="cairo? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!cairo? ( test )"

RDEPEND="
	sys-apps/lsb-release
	cairo? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	)
"
BDEPEND="cairo? ( ${PYTHON_DEPS} )"

CONFIG_CHECK="~PROC_EVENTS ~TASKSTATS ~TASK_DELAY_ACCT ~TMPFS"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.8-no-compressed-man.patch
	"${FILESDIR}"/${P}-glibc-2.36.patch
)

pkg_setup() {
	use cairo && python-single_r1_pkg_setup
}

src_prepare() {
	default

	tc-export CC

	# Redirects systemd unit directory,
	# as well as disable the built-in python setup.
	sed -i \
		-e "/^SYSTEMD_UNIT_DIR/s:=.*:= $(systemd_get_systemunitdir):g" \
		-e "/^install/s:py-install-compile::g" \
		-e "/pybootchartgui.1/d" \
		Makefile || die

	sed -i \
		-e '/^EXIT_PROC/s:^.*$:EXIT_PROC="agetty mgetty mingetty:g' \
		bootchartd.conf bootchartd.in || die
}

src_test() {
	emake test
}

src_install() {
	export DOCDIR=/usr/share/doc/${PF}
	default

	if use cairo; then
		doman pybootchartgui.1

		python_scriptinto /usr/bin
		python_newscript pybootchartgui{.py,}

		python_domodule pybootchartgui
		python_optimize
	fi

	# Note: LIBDIR is hardcoded as /lib in collector/common.h, so we shouldn't
	# just change it. Since no libraries are installed, /lib is fine.
	keepdir /lib/bootchart/tmpfs

	newinitd "${FILESDIR}"/${PN}.init ${PN}
}

pkg_postinst() {
	elog "If you are using an initrd during boot"
	elog "please add the init script to your default runlevel"
	if has_version sys-apps/openrc; then
		elog "rc-update add bootchart2 default"
	fi
}
