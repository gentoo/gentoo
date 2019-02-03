# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils libtool multilib toolchain-funcs multilib-minimal

DESCRIPTION="Stream-oriented XML parser library"
HOMEPAGE="https://libexpat.github.io/"
SRC_URI="mirror://sourceforge/expat/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="elibc_FreeBSD examples static-libs unicode"
RDEPEND=""

DOCS=( AUTHORS Changes README )

PATCHES=(
	"${FILESDIR}"/${P}-getrandom-detection.patch
	"${FILESDIR}"/${P}-posix-shell.patch
	"${FILESDIR}"/${P}-gentoo-dash.patch  # bug 622360
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf="$(use_enable static-libs static)"

	mkdir -p "${BUILD_DIR}"{u,w} || die

	ECONF_SOURCE="${S}" econf ${myconf}

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		CPPFLAGS="${CPPFLAGS} -DXML_UNICODE" ECONF_SOURCE="${S}" econf ${myconf}
		popd >/dev/null
	fi
}

multilib_src_compile() {
	emake

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		emake buildlib LIBRARY=libexpatw.la
		popd >/dev/null
	fi
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		emake installlib DESTDIR="${D}" LIBRARY=libexpatw.la
		popd >/dev/null

		pushd "${ED}"/usr/$(get_libdir)/pkgconfig >/dev/null
		cp expat.pc expatw.pc
		sed -i -e '/^Libs/s:-lexpat:&w:' expatw.pc || die
		popd >/dev/null
	fi

	if multilib_is_native_abi ; then
		# libgeom in /lib and ifconfig in /sbin require libexpat on FreeBSD since
		# we stripped the libbsdxml copy starting from freebsd-lib-8.2-r1
		use elibc_FreeBSD && gen_usr_ldscript -a expat
	fi
}

multilib_src_install_all() {
	einstalldocs

	# Note: Use of HTML_DOCS would add unwanted "doc" subfolder
	docinto html
	dodoc doc/*.{css,html,png}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi

	prune_libtool_files
}
