# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit meson python-single-r1

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
	inherit git-r3
else
	SRC_URI="https://www.kernel.org/pub/software/utils/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Open Firmware device tree compiler"
HOMEPAGE="https://devicetree.org/ https://git.kernel.org/cgit/utils/dtc/dtc.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE="python static-libs test yaml"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	sys-devel/bison
	app-alternatives/lex
	virtual/pkgconfig
	python? ( dev-lang/swig )
"
RDEPEND="
	python? ( ${PYTHON_DEPS} )
	yaml? ( dev-libs/libyaml )
"
DEPEND="${RDEPEND}"

DOCS=(
	Documentation/dt-object-internal.txt
	Documentation/dts-format.txt
	Documentation/manual.txt
)

PATCHES=(
	"${FILESDIR}"/${P}-meson-tests.patch
	"${FILESDIR}"/${P}-meson-macos.patch
)

pkg_setup() {
	if use python ; then
		export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	default

	if ! use test ; then
		sed -i -e "/subdir('tests')/d" meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dtools=true
		-Dvalgrind=disabled # only used for some tests
		$(meson_feature python)
		$(meson_feature yaml)
	)

	# bug #909366
	use static-libs && emesonargs+=( -Dstatic-build=true )

	meson_src_configure
}
