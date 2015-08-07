# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/talloc/talloc-2.1.3.ebuild,v 1.1 2015/08/07 07:31:04 polynomial-c Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit waf-utils python-single-r1 multilib multilib-minimal

DESCRIPTION="Samba talloc library"
HOMEPAGE="http://talloc.samba.org/"
SRC_URI="http://samba.org/ftp/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3+ LGPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~sparc-solaris"
IUSE="compat +python"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="python? ( ${PYTHON_DEPS} )
	!!<sys-libs/talloc-2.0.5
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-libs/libxslt
	${PYTHON_DEPS}"

WAF_BINARY="${S}/buildtools/bin/waf"

MULTILIB_WRAPPED_HEADERS=(
	# python goes only for native
	/usr/include/pytalloc.h
)

src_prepare() {
	# what would you expect of waf? i won't even waste time trying.
	multilib_copy_sources
}

multilib_src_configure() {
	local extra_opts=()

	use compat && extra_opts+=( --enable-talloc-compat1 )
	if ! multilib_is_native_abi || ! use python; then
		extra_opts+=( --disable-python )
	fi

	waf-utils_src_configure \
		"${extra_opts[@]}"
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	# waf is stupid, and no, we can't fix the build-system, since it's provided
	# as a brilliant binary blob thats decompressed on the fly
	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libtalloc.2.0.5.dylib || die
		if use python ; then
			install_name_tool \
				-id "${EPREFIX}"/usr/$(get_libdir)/libpytalloc-util.2.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.2.0.5.dylib || die
			install_name_tool \
				-change "${S}/bin/default/libtalloc.dylib" \
					"${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.2.0.5.dylib || die
			install_name_tool \
				-change "${S}/bin/default/libtalloc.dylib" \
					"${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
				"${ED}"$(python_get_sitedir)/talloc.bundle || die
		fi
	fi
}
