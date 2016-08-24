# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils linux-info python-single-r1 python-utils-r1

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"
EGIT_COMMIT="v${PV}"
SRC_URI="https://github.com/iovisor/bcc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="test"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=sys-devel/llvm-3.7:=
	sys-devel/clang
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
S=${WORKDIR}/${PN}-${EGIT_COMMIT#v}

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~BPF_JIT ~HAVE_BPF_JIT ~BPF_EVENTS"

	check_extra_config
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	#582770 don't use static libstdc++
	sed -i -e '21,33d' src/cc/CMakeLists.txt || die
	default
}

src_configure() {
	local mycmakeargs=(
		-DREVISION=${PV%%_*}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"
}
