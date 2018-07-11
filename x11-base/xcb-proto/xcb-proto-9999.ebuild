# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit multilib-minimal python-r1

DESCRIPTION="X C-language Bindings protocol headers"
HOMEPAGE="https://xcb.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xcb/proto.git"
	inherit autotools git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	SRC_URI="https://xcb.freedesktop.org/dist/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/libxml2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

# src_configure() {
# 	python_setup

# }

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf

	if multilib_is_native_abi; then
		ECONF_SOURCE="${S}" python_foreach_impl run_in_build_dir econf
	fi
}

multilib_src_compile() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl emake -C xcbgen
	fi
}

# src_install() {
# 	default

# }

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" -C xcbgen install
	fi
	# pkg-config file hardcodes python sitedir, bug 486512
	sed -i -e '/pythondir/s:=.*$:=/dev/null:' \
		"${ED%/}"/usr/$(get_libdir)/pkgconfig/xcb-proto.pc || die
}
