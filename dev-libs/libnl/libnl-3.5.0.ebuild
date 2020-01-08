# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
DISTUTILS_OPTIONAL=1
inherit distutils-r1 libtool multilib-minimal

LIBNL_P=${P/_/-}
LIBNL_DIR=${PV/_/}
LIBNL_DIR=${LIBNL_DIR//./_}

DESCRIPTION="Libraries providing APIs to netlink protocol based Linux kernel interfaces"
HOMEPAGE="http://www.infradead.org/~tgr/libnl/ https://github.com/thom311/libnl"
SRC_URI="
	https://github.com/thom311/${PN}/releases/download/${PN}${LIBNL_DIR}/${P/_rc/-rc}.tar.gz
"
LICENSE="LGPL-2.1 utils? ( GPL-2 )"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+debug static-libs python +threads utils"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	python? ( dev-lang/swig )
	sys-devel/bison
	sys-devel/flex
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
DOCS=(
	ChangeLog
)

S=${WORKDIR}/${LIBNL_P}

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

src_prepare() {
	default

	elibtoolize

	if use python; then
		cd "${S}"/python || die
		distutils-r1_src_prepare
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
		--disable-silent-rules
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		# Unset DOCS= since distutils-r1.eclass interferes
		local DOCS=()
		cd python || die
		distutils-r1_src_install
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
