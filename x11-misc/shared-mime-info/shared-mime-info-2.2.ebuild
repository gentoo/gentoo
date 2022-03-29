# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson toolchain-funcs xdg-utils

# Keep an eye on https://gitlab.freedesktop.org/xdg/xdgmime/-/merge_requests/25!
# xdgmime is used for tests but doesn't make releases nowadays; do what
# Fedora does and use a snapshot so we can run the test suite.
MY_XDGMIME_COMMIT="92f6a09fda2b23c2ab95cede8eb0612ca96bd0f7"
DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="https://gitlab.freedesktop.org/xdg/shared-mime-info"
SRC_URI="https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${PV}/${P}.tar.gz"
SRC_URI+=" test? ( https://gitlab.freedesktop.org/xdg/xdgmime/-/archive/${MY_XDGMIME_COMMIT}/xdgmime-${MY_XDGMIME_COMMIT}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"

DOCS=( HACKING.md NEWS README.md )

src_prepare() {
	default

	if use test ; then
		# Drop empty dir (it's a submodule in upstream git repo)
		rm -r "${S}"/xdgmime || die
		# Lead Meson to our snapshot
		ln -s "${WORKDIR}"/xdgmime-${MY_XDGMIME_COMMIT} xdgmime || die
		# Don't break parallel make
		sed -i -e 's:make:$(MAKE):' xdgmime/Makefile || die
	fi
}

src_configure() {
	# We have to trick Meson into thinking it's there now so that
	# we can run meson then emake to build xdgmime later, rather than
	# building before running meson which would mean doing something
	# unexpected in src_configure.
	if use test ; then
		# Paths from https://gitlab.freedesktop.org/xdg/shared-mime-info/-/blob/master/meson.build#L29
		touch xdgmime/src/{print,test}-mime{,-data} || die
		chmod +x xdgmime/src/{print,test}-mime{,-data} || die
	fi

	local emesonargs=(
		-Dbuild-tools=true
		-Dupdate-mimedb=false
	)

	meson_src_configure
}

src_compile() {
	if use test ; then
		tc-export CC

		# xdgmime only has a homebrew Makefile
		emake -C xdgmime
	fi

	meson_src_compile
}

src_install() {
	meson_src_install

	# in prefix, install an env.d entry such that prefix patch is used/added
	if use prefix; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share\"" > "${T}"/50mimeinfo || die
		doenvd "${T}"/50mimeinfo
	fi
}

pkg_postinst() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	xdg_mimeinfo_database_update
}
