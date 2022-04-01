# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gstreamer-meson pax-utils

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps +introspection +orc unwind"

RDEPEND="
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
	!<media-libs/gst-plugins-bad-1.13.1:1.0
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
	sys-devel/bison
	sys-devel/flex
"

multilib_src_configure() {
	local emesonargs=(
		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dcheck=enabled
		$(meson_feature unwind libunwind)
		$(meson_feature unwind libdw)
	)

	if use caps ; then
		emesonargs+=( -Dptp-helper-permissions=capabilities )
	else
		emesonargs+=(
			-Dptp-helper-permissions=setuid-root
			-Dptp-helper-setuid-user=nobody
			-Dptp-helper-setuid-group=nobody
		)
	fi

	gstreamer_multilib_src_configure
}

multilib_src_install() {
	# can't do "default", we want to install docs in multilib_src_install_all
	DESTDIR="${D}" eninja install

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}/usr/$(get_libdir)/gstreamer-${SLOT}/gst-plugin-scanner"
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}/usr/bin/gst-launch-${SLOT}"
}
