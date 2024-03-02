# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We avoid xdg.eclass here because it'll pull in glib, desktop utils on
# htop which is often used on headless machines. bug #787470
inherit linux-info optfeature xdg-utils

DESCRIPTION="Interactive process viewer"
HOMEPAGE="https://htop.dev/ https://github.com/htop-dev/htop"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/htop-dev/htop.git"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/htop-dev/htop/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

S="${WORKDIR}/${P/_}"

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="caps debug delayacct hwloc lm-sensors llvm-libunwind openvz unicode unwind vserver"

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
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.0-display-running-tasks.patch
)

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	if [[ ${CBUILD} != ${CHOST} ]] ; then
		# bug #328971
		export ac_cv_file__proc_{meminfo,stat}=yes
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

	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "Viewing processes accessing certain files" sys-process/lsof
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
