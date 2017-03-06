# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE=xml

XORG_DOC=doc
XORG_MULTILIB=yes
XORG_EAUTORECONF=yes
inherit python-any-r1 xorg-2

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/libxcb"
[[ ${PV} != 9999* ]] && \
	SRC_URI="https://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc selinux test xkb"
SLOT="0/1.12" # Locked down for now to 1.12 to avoid further rebuilds on no ABI changes (e.g with any upcoming 1.12.1 bugfix release), bug 576890

RDEPEND=">=dev-libs/libpthread-stubs-0.3-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]"
# Note: ${PYTHON_USEDEP} needs to go verbatim
DEPEND="${RDEPEND}
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
	doc? ( app-doc/doxygen[dot] )
	dev-libs/libxslt
	${PYTHON_DEPS}
	$(python_gen_any_dep \
		">=x11-proto/xcb-proto-1.12-r1[${MULTILIB_USEDEP},\${PYTHON_USEDEP}]")"

python_check_deps() {
	has_version --host-root ">=x11-proto/xcb-proto-1.11[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

PATCHES=(
	"${FILESDIR}/${PN}-1.11-Don-t-install-headers-man-pages-for-disabled-extensi.patch"
	"${FILESDIR}/${P}-fix-inconsistent-use-tabs-space.patch"
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc devel-docs)
		$(use_enable selinux)
		$(use_enable xkb)
		--enable-xinput
	)
	xorg-2_src_configure
}
