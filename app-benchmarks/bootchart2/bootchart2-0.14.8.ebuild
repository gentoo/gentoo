# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_6 )

inherit linux-info python-r1 systemd toolchain-funcs

DESCRIPTION="Performance analysis and visualization of the system boot process"
HOMEPAGE="https://github.com/mmeeks/bootchart/"
SRC_URI="https://github.com/mmeeks/bootchart/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="svg test X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	X? ( ${PYTHON_REQUIRED_USE} )
	test? ( X )"

RDEPEND="
	!app-benchmarks/bootchart
	X? (
		dev-python/pycairo[svg(+)?,${PYTHON_USEDEP}]
		dev-python/pygtk[$(python_gen_usedep 'python2*')]
		${PYTHON_DEPS}
	)
	sys-apps/lsb-release"
DEPEND="${PYTHON_DEPS}"

S="${WORKDIR}"/${PN%2}-${PV}

CONFIG_CHECK="~PROC_EVENTS ~TASKSTATS ~TASK_DELAY_ACCT ~TMPFS"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.14.7-sysmacros.patch #579922
	tc-export CC
	sed -i \
		-e "/^install/s:py-install-compile::g" \
		-e "/^SYSTEMD_UNIT_DIR/s:=.*:= $(systemd_get_unitdir):g" \
		Makefile || die
	sed -i \
		-e '/^EXIT_PROC/s:^.*$:EXIT_PROC="agetty mgetty mingetty:g' \
		bootchartd.conf bootchartd.in || die
}

src_test() {
	python_foreach_impl emake test
}

src_install() {
	export DOCDIR=/usr/share/doc/${PF}
	default

	# Note: LIBDIR is hardcoded as /lib in collector/common.h, so we shouldn't
	# just change it. Since no libraries are installed, /lib is fine.
	keepdir /lib/bootchart/tmpfs

	installation() {
		python_domodule pybootchartgui

		python_newscript pybootchartgui.py pybootchartgui
	}
	use X && python_foreach_impl installation

	newinitd "${FILESDIR}"/${PN}.init ${PN}

}

pkg_postinst() {
	elog "If you are using an initrd during boot"
	echo
	elog "please add the init script to your default runlevel"
	elog "rc-update add bootchart2 default"
	echo
}
