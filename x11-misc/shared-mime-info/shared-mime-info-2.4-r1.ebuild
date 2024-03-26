# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

# xdgmime is used for tests but doesn't make releases nowadays; do what
# Fedora does and use a snapshot so we can run the test suite.
MY_XDGMIME_COMMIT="179296748e92bd91bf531656632a1056307fb7b7"
DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="https://gitlab.freedesktop.org/xdg/shared-mime-info"
SRC_URI="https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${PV}/${P}.tar.bz2"
SRC_URI+=" test? ( https://gitlab.freedesktop.org/xdg/xdgmime/-/archive/${MY_XDGMIME_COMMIT}/xdgmime-${MY_XDGMIME_COMMIT}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
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

PATCHES=(
	"${FILESDIR}"/${P}-libxml2.12.patch
)

src_prepare() {
	default

	if use test ; then
		# Drop empty dir (it's a submodule in upstream git repo)
		rm -r "${S}"/xdgmime || die
		# Lead Meson to our snapshot
		mkdir "${WORKDIR}"/xdgmime_build || die
		ln -s "${WORKDIR}"/xdgmime_build xdgmime || die
		# Don't break parallel make
		#sed -i -e 's:make:$(MAKE):' xdgmime/Makefile || die
	fi
}

src_configure() {
	# We have to trick Meson into thinking it's there now so that
	# we can run meson then emake to build xdgmime later, rather than
	# building before running meson which would mean doing something
	# unexpected in src_configure.
	if use test ; then
		# Paths from https://gitlab.freedesktop.org/xdg/shared-mime-info/-/blob/master/meson.build#L29
		mkdir xdgmime/src || die
		touch xdgmime/src/{print,test}-mime{,-data} || die
		chmod +x xdgmime/src/{print,test}-mime{,-data} || die

		BUILD_DIR="${WORKDIR}"/xdgmime_build EMESON_SOURCE="${WORKDIR}"/xdgmime-${MY_XDGMIME_COMMIT} meson_src_configure
	fi

	local emesonargs=(
		-Dbuild-tools=true
		-Dupdate-mimedb=false
		$(meson_use test build-tests)
	)

	meson_src_configure
}

src_compile() {
	if use test ; then
		meson_src_compile -C "${WORKDIR}"/xdgmime_build
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
