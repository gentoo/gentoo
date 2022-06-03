# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools fcaps linux-info python-any-r1 xdg-utils

DESCRIPTION="interactive process viewer"
HOMEPAGE="https://htop.dev/ https://github.com/htop-dev/htop"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/htop-dev/htop.git"
else
	SRC_URI="https://github.com/htop-dev/${PN}/archive/${PV/_}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="caps debug delayacct hwloc lm-sensors llvm-libunwind openvz unicode unwind vserver"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	hwloc? ( sys-apps/hwloc:= )
	unwind? (
		!llvm-libunwind? ( sys-libs/libunwind:= )
		llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	)
	kernel_linux? (
		caps? ( sys-libs/libcap )
		delayacct? ( dev-libs/libnl:3 )
		lm-sensors? ( sys-apps/lm-sensors )
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

S="${WORKDIR}/${P/_}"

pkg_setup() {
	if ! has_version sys-process/lsof ; then
		ewarn "To use lsof features in htop (what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi

	python-any-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	if [[ ${CBUILD} != ${CHOST} ]] ; then
		export ac_cv_file__proc_{meminfo,stat}=yes #328971
	fi

	local myeconfargs=(
		--enable-unicode
		$(use_enable debug)
		$(use_enable hwloc)
		$(use_enable !hwloc affinity)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable unwind)
		$(use_enable vserver)
	)

	if use kernel_linux ; then
		myeconfargs+=(
			$(use_enable caps capabilities)
			$(use_enable delayacct)
			$(use_enable lm-sensors sensors)
		)
	else
		if use kernel_Darwin ; then
			# Upstream default to checking but --enable-affinity
			# overrides this. Simplest to just disable on Darwin
			# given it works on BSD anyway.
			myeconfargs+=( --disable-affinity )
		fi

		myeconfargs+=(
			--disable-capabilities
			--disable-delayacct
			--disable-sensors
		)
	fi

	econf ${myeconfargs[@]}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	fcaps cap_sys_ptrace /usr/bin/${PN}
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
