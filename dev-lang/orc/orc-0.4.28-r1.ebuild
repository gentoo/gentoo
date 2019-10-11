# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic multilib-minimal pax-utils

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples pax_kernel static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
"

DOCS=( README RELEASE )

src_prepare() {
	default

	# Do not build examples
	sed -e '/SUBDIRS/ s:examples::' \
		-i Makefile.am Makefile.in || die
}

multilib_src_configure() {
	# any optimisation on PPC/Darwin yields in a complaint from the assembler
	# Parameter error: r0 not allowed for parameter %lu (code as 0 not r0)
	# the same for Intel/Darwin, although the error message there is different
	# but along the same lines
	[[ ${CHOST} == *-darwin* ]] && filter-flags -O*

	# FIXME: handle backends per arch? What about cross-compiling for the other arches?
	ECONF_SOURCE="${S}" econf \
		--disable-gtk-doc \
		--enable-backend=all \
		$(use_enable static-libs static)
		# TODO: bug #645232 - Not ready for this yet, as it installs some headers to live and gst-plugins-base:0.10 includes some
		# Additionally it doesn't seem good that FEATURES=test would change what files are installed (headers + orctest.so + orc-bugreport)
		# $(use_enable test tests)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all

	if use pax_kernel; then
		pax-mark m "${ED}"usr/bin/orc-bugreport
		pax-mark m "${ED}"usr/bin/orcc
		pax-mark m "${ED}"usr/$(get_libdir)/liborc*.so*
	fi
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,*.orc}
	fi
}

pkg_postinst() {
	if use pax_kernel; then
		ewarn "Please run \"revdep-pax\" after installation".
		ewarn "It's provided by sys-apps/elfix."
	fi
}
