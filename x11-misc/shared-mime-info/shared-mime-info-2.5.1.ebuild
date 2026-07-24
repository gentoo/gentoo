# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1 xdg-utils

# xdgmime is used for tests but doesn't make releases nowadays; do what
# Fedora does and use a snapshot so we can run the test suite.
MY_XDGMIME_COMMIT="04ce4cd90cb3fa77d5348662de221a6f33b21b17"

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="https://gitlab.freedesktop.org/xdg/shared-mime-info"
SRC_URI="https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${PV}/${P}.tar.bz2"
SRC_URI+=" test? ( https://gitlab.freedesktop.org/xdg/xdgmime/-/archive/${MY_XDGMIME_COMMIT}/xdgmime-${MY_XDGMIME_COMMIT}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	if use test ; then
		# Lead Meson to our snapshot
		ln -s "${WORKDIR}"/xdgmime-${MY_XDGMIME_COMMIT} subprojects/xdgmime || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dbuild-tools=true
		-Dbuild-spec=false
		-Dupdate-mimedb=false
		$(meson_use test build-tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# in prefix, install an env.d entry such that prefix path is used/added
	if use prefix; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share\"" > "${T}"/50mimeinfo || die
		doenvd "${T}"/50mimeinfo
	fi
}

pkg_postrm() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	xdg_mimeinfo_database_update
}
