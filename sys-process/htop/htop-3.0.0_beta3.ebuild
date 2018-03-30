# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit autotools linux-info python-single-r1

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://hisham.hm/htop/"
if [[ "${PV}" = *_beta* ]] ; then
	SRC_URI="https://github.com/hishamhm/${PN}/archive/${PV/_}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P/_}"
else
	SRC_URI="http://hisham.hm/htop/releases/${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
fi
LICENSE="BSD GPL-2"
SLOT="0"
IUSE="kernel_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses:0=[unicode?]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

PATCHES=(

	# Fixes from upstream (can usually be removed with next version bump)
	"${FILESDIR}/${PN}-2.1.0-header_updates.patch"
)

pkg_setup() {
	if ! has_version sys-process/lsof; then
		ewarn "To use lsof features in htop(what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi

	python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	if [[ "${PV}" != *_beta* ]] ; then
		rm missing || die
	fi

	default
	use python_single_target_python2_7 || \
		eapply "${FILESDIR}/${PN}-2.1.0-MakeHeader-python3.patch" #646880
	eautoreconf
	python_fix_shebang scripts/MakeHeader.py
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=(
		# fails to build against recent hwloc versions
		--disable-hwloc
		--enable-taskstats
		$(use_enable kernel_linux cgroup)
		$(use_enable kernel_linux linux-affinity)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable vserver)
	)
	econf ${myeconfargs[@]}
}
