# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1 multilib-minimal toolchain-funcs

DESCRIPTION="D-Bus bindings for glib"
HOMEPAGE="https://dbus.freedesktop.org/"
SRC_URI="https://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.8[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-libs/expat-2.1.0-r3
	>=dev-libs/glib-2.40:2
	>=sys-apps/dbus-1.8
	>=dev-util/glib-utils-2.40
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
" # CBUILD dependencies are needed to make a native tool while cross-compiling.

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

PATCHES=( "${FILESDIR}"/${P}-config-glib-genmarshal.conf )

set_TBD() {
	# out of sources build dir for make check
	export TBD="${BUILD_DIR}-tests"
}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
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
		cd "${TBD}" || die
		einfo "Running make in ${TBD}"
		emake
	fi
}

multilib_src_test() {
	set_TBD
	cd "${TBD}" || die
	emake check
}

multilib_src_install_all() {
	einstalldocs

	newbashcomp "${ED}"/etc/bash_completion.d/dbus-bash-completion.sh dbus-send
	rm -rf "${ED}"/etc/bash_completion.d || die

	find "${ED}" -type f -name '*.la' -delete || die
}
