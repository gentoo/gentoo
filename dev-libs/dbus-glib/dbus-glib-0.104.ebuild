# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dbus-glib/dbus-glib-0.104.ebuild,v 1.1 2015/07/04 15:51:15 pacho Exp $

EAPI=5
inherit bash-completion-r1 eutils multilib-minimal

DESCRIPTION="D-Bus bindings for glib"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs test"

CDEPEND="
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.8[${MULTILIB_USEDEP}]
"
DEPEND="${CDEPEND}
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-baselibs-20131008-r8
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

set_TBD() {
	# out of sources build dir for make check
	export TBD="${BUILD_DIR}-tests"
}

src_prepare() {
	epatch_user
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}"/var
		--enable-bash-completion
		--disable-gtk-doc
		$(use_enable debug asserts)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	ln -s "${S}"/doc/reference/html doc/reference/html #460042

	if use test; then
		set_TBD
		mkdir "${TBD}"
		cd "${TBD}"
		einfo "Running configure in ${TBD}"
		ECONF_SOURCE="${S}" econf \
			"${myconf[@]}" \
			$(use_enable test checks) \
			$(use_enable test tests) \
			$(use_enable test asserts) \
			$(use_with test test-socket-dir "${T}"/dbus-test-socket)
	fi
}

multilib_src_compile() {
	emake

	if use test; then
		set_TBD
		cd "${TBD}"
		einfo "Running make in ${TBD}"
		emake
	fi
}

multilib_src_test() {
	set_TBD
	cd "${TBD}"
	emake check
}

multilib_src_install_all() {
	einstalldocs

	newbashcomp "${ED}"/etc/bash_completion.d/dbus-bash-completion.sh dbus-send
	rm -rf "${ED}"/etc/bash_completion.d || die

	prune_libtool_files
}
