# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..11} )

inherit linux-info meson python-single-r1

DESCRIPTION="User-space front-end for Ftrace"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/${PV}"
IUSE="python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# Tests segfault for now?
RESTRICT="!test? ( test ) test"

RDEPEND="
	>=app-arch/zstd-1.4
	!<dev-libs/libtracefs-1.6.1
	>=dev-libs/libtracefs-1.6.1-r1
	>=dev-libs/libtraceevent-1.6.3
	sys-libs/zlib
	sys-process/audit
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
	test? ( dev-util/cunit )
"
BDEPEND="
	app-text/asciidoc
	dev-util/source-highlight
	virtual/pkgconfig
	python? ( dev-lang/swig )
"

pkg_setup() {
	local CONFIG_CHECK="
		~TRACING
		~FTRACE
		~BLK_DEV_IO_TRACE"

	linux-info_pkg_setup

	# TODO: Once we have options for doc+tests, we can revisit Python being
	# single-impl.
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dasciidoctor=false
		$(meson_use python)
	)

	# TODO: udis86 isn't wired up to meson at all
	# TODO: get docs & tests optional upstream
	# TODO: audit/zstd/zlib lack meson options for now. Previously, the situation
	# was somewhat automagic, so this isn't a huge loss for now, but we should
	# upstream some build options for these.
	meson_src_configure
}
