# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit autotools distutils-r1 multilib-minimal

LIBNL_P=${P/_/-}
LIBNL_DIR=${PV/_/}
LIBNL_DIR=${LIBNL_DIR//./_}

DESCRIPTION="Libraries providing APIs to netlink protocol based Linux kernel interfaces"
HOMEPAGE="https://www.infradead.org/~tgr/libnl/ https://github.com/thom311/libnl"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/thom311/libnl"
	inherit git-r3
else
	SRC_URI="https://github.com/thom311/${PN}/releases/download/${PN}${LIBNL_DIR}/${P/_rc/-rc}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

	S="${WORKDIR}/${LIBNL_P}"
fi

LICENSE="LGPL-2.1 utils? ( GPL-2 )"
SLOT="3"
IUSE="+debug python test utils"
RESTRICT="!test? ( test )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	python? (
		${DISTUTILS_DEPS}
		dev-lang/swig
	)
	test? ( dev-libs/check )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

MULTILIB_WRAPPED_HEADERS=(
	# we do not install CLI stuff for non-native
	/usr/include/libnl3/netlink/cli/addr.h
	/usr/include/libnl3/netlink/cli/class.h
	/usr/include/libnl3/netlink/cli/cls.h
	/usr/include/libnl3/netlink/cli/ct.h
	/usr/include/libnl3/netlink/cli/exp.h
	/usr/include/libnl3/netlink/cli/link.h
	/usr/include/libnl3/netlink/cli/mdb.h
	/usr/include/libnl3/netlink/cli/neigh.h
	/usr/include/libnl3/netlink/cli/qdisc.h
	/usr/include/libnl3/netlink/cli/route.h
	/usr/include/libnl3/netlink/cli/rule.h
	/usr/include/libnl3/netlink/cli/tc.h
	/usr/include/libnl3/netlink/cli/utils.h
)

src_prepare() {
	default

	eautoreconf

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

multilib_src_configure() {
	# bug #884277
	export YACC=yacc.bison

	ECONF_SOURCE="${S}" econf \
		$(multilib_native_use_enable utils cli) \
		$(use_enable debug)
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python ; then
		pushd python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use python ; then
		# Unset DOCS= since distutils-r1.eclass interferes
		local DOCS=()

		pushd python > /dev/null || die

		distutils-r1_src_install

		popd > /dev/null || die
	fi
}

multilib_src_install_all() {
	DOCS=( ChangeLog )

	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
