# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="D-Bus bindings for glib"
HOMEPAGE="https://dbus.freedesktop.org/"
SRC_URI="https://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.8[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
# CBUILD dependencies are needed to make a native tool while cross-compiling.
BDEPEND="
	>=dev-libs/expat-2.1.0-r3
	>=dev-libs/glib-2.40:2
	>=sys-apps/dbus-1.8
	>=dev-util/glib-utils-2.40
	>=dev-build/gtk-doc-am-1.14
	virtual/pkgconfig
"

DOCS=( AUTHORS CONTRIBUTING.md NEWS README )

set_TBD() {
	# out of sources build dir for make check
	export TBD="${BUILD_DIR}-tests"
}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# bug #923801
	append-lfs-flags

	local myconf=(
		--localstatedir="${EPREFIX}"/var
		--enable-bash-completion
		--disable-gtk-doc
		$(use_enable debug asserts)
		$(use_enable static-libs static)
	)

	# Configure a CBUILD directory to make a native build tool.
	if tc-is-cross-compiler; then
		mkdir "${BUILD_DIR}-build" || die
		cd "${BUILD_DIR}-build" || die
		ECONF_SOURCE="${S}" econf_build
		myconf+=( --with-dbus-binding-tool="$PWD/dbus/dbus-binding-tool" )
		cd - || die
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	ln -s "${S}"/doc/reference/html doc/reference/html || die #460042

	if use test; then
		set_TBD
		mkdir "${TBD}" || die
		cd "${TBD}" || die
		einfo "Running configure in ${TBD}"
		ECONF_SOURCE="${S}" econf \
			"${myconf[@]}" \
			$(use_enable test checks) \
			$(use_enable test tests) \
			$(use_enable test asserts)
	fi
}

multilib_src_compile() {
	tc-is-cross-compiler && emake -C "${BUILD_DIR}-build"

	emake

	if use test; then
		set_TBD
		emake -C "${TBD}"
	fi
}

multilib_src_test() {
	set_TBD
	emake -C "${TBD}" check
}

multilib_src_install_all() {
	einstalldocs

	newbashcomp "${ED}"/etc/bash_completion.d/dbus-bash-completion.sh dbus-send
	rm -r "${ED}"/etc/bash_completion.d || die

	find "${ED}" -type f -name '*.la' -delete || die
}
