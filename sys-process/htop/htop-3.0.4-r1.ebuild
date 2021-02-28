# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit autotools linux-info python-any-r1

DESCRIPTION="interactive process viewer"
HOMEPAGE="https://htop.dev/ https://github.com/htop-dev/htop"
SRC_URI="https://github.com/htop-dev/${PN}/archive/${PV/_}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

LICENSE="BSD GPL-2"
SLOT="0"
IUSE="debug hwloc kernel_FreeBSD kernel_linux lm-sensors openvz unicode vserver"

BDEPEND="virtual/pkgconfig"
RDEPEND="sys-libs/ncurses:0=[unicode?]
	hwloc? ( sys-apps/hwloc )
	lm-sensors? ( sys-apps/lm-sensors )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

S="${WORKDIR}/${P/_}"

PATCHES=(
	"${FILESDIR}/${P}-sort_column_header_highlight.patch"
)

pkg_setup() {
	if ! has_version sys-process/lsof; then
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
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable hwloc)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable vserver)
		$(use_with lm-sensors sensors)
	)

	if ! use hwloc && use kernel_linux ; then
		myeconfargs+=( --enable-linux-affinity )
	else
		myeconfargs+=( --disable-linux-affinity )
	fi

	econf ${myeconfargs[@]}
}
