# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 multilib-minimal pax-utils

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps +introspection nls +orc test unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
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
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.14.5-make43.patch # remove when bumping and switching to Meson
)

src_configure() {
	if [[ ${CHOST} == *-interix* ]] ; then
		export ac_cv_lib_dl_dladdr=no
		export ac_cv_func_poll=no
	fi
	if [[ ${CHOST} == powerpc-apple-darwin* ]] ; then
		# GCC groks this, but then refers to an implementation (___multi3,
		# ___udivti3) that don't exist (at least I can't find it), so force
		# this one to be off, such that we use 2x64bit emulation code.
		export gst_cv_uint128_t=no
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local completiondir=$(get_bashcompdir)
	# Set 'libexecdir' to ABI-specific location for the library spawns
	# helpers from there.
	# Disable static archives and examples to speed up build time
	# Disable debug, as it only affects -g passing (debugging symbols), this must done through make.conf in gentoo
	local myconf=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		--disable-benchmarks
		--disable-debug
		--disable-examples
		--disable-static
		--disable-valgrind
		--enable-check
		$(use_with unwind)
		$(use_with unwind dw)
		$(multilib_native_use_enable introspection)
		$(use_enable nls)
		$(use_enable test tests)
		--with-bash-completion-dir="${completiondir%/*}"
		--with-package-name="GStreamer ebuild for Gentoo"
		--with-package-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
	)

	if use caps ; then
		myconf+=( --with-ptp-helper-permissions=capabilities )
	else
		myconf+=(
			--with-ptp-helper-permissions=setuid-root
			--with-ptp-helper-setuid-user=nobody
			--with-ptp-helper-setuid-group=nobody
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	if multilib_is_native_abi; then
		local x
		for x in gst libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_install() {
	# can't do "default", we want to install docs in multilib_src_install_all
	emake DESTDIR="${D}" install

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/$(get_libdir)/gstreamer-${SLOT}/gst-plugin-scanner"
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/bin/gst-launch-${SLOT}"
}
