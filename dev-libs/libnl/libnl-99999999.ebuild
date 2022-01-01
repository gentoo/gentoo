# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_OPTIONAL=1
inherit autotools distutils-r1 git-r3 multilib-minimal

DESCRIPTION="Libraries providing APIs to netlink protocol based Linux kernel interfaces"
HOMEPAGE="http://www.infradead.org/~tgr/libnl/ https://github.com/thom311/libnl"
EGIT_REPO_URI="https://github.com/thom311/libnl"
LICENSE="LGPL-2.1 utils? ( GPL-2 )"
SLOT="3"
KEYWORDS=""
IUSE="+debug static-libs python +threads utils"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	python? ( dev-lang/swig )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
DOCS=(
	ChangeLog
)
MULTILIB_WRAPPED_HEADERS=(
	# we do not install CLI stuff for non-native
	/usr/include/libnl3/netlink/cli/addr.h
	/usr/include/libnl3/netlink/cli/class.h
	/usr/include/libnl3/netlink/cli/cls.h
	/usr/include/libnl3/netlink/cli/ct.h
	/usr/include/libnl3/netlink/cli/exp.h
	/usr/include/libnl3/netlink/cli/link.h
	/usr/include/libnl3/netlink/cli/neigh.h
	/usr/include/libnl3/netlink/cli/qdisc.h
	/usr/include/libnl3/netlink/cli/route.h
	/usr/include/libnl3/netlink/cli/rule.h
	/usr/include/libnl3/netlink/cli/tc.h
	/usr/include/libnl3/netlink/cli/utils.h
)
PATCHES=(
	"${FILESDIR}"/${PN}-99999999-2to3.patch
)

src_prepare() {
	default

	eautoreconf

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi

	# out-of-source build broken
	# https://github.com/thom311/libnl/pull/58
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(multilib_native_use_enable utils cli) \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		--disable-doc
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python; then
		pushd python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use python; then
		# Unset DOCS= since distutils-r1.eclass interferes
		local DOCS=()

		pushd python > /dev/null || die

		distutils-r1_src_install

		# For no obvious reason this is not done automatically
		python_foreach_impl python_optimize

		popd > /dev/null || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
