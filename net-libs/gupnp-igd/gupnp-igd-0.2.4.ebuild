# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gupnp-igd/gupnp-igd-0.2.4.ebuild,v 1.4 2015/06/21 08:54:05 jer Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=true

inherit eutils gnome.org python-r1 multilib-minimal

DESCRIPTION="Library to handle UPnP IGD port mapping for GUPnP"
HOMEPAGE="http://gupnp.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="+introspection python"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=net-libs/gssdp-0.14.7[${MULTILIB_USEDEP}]
	>=net-libs/gupnp-0.20.10[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10 )
	python? (
		>=dev-libs/gobject-introspection-0.10
		>=dev-python/pygobject-2.16:2[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

# The only existing test is broken
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.11-disable_static_modules.patch
)

multilib_src_configure() {
	local myconf=(
		--disable-static
		--disable-gtk-doc
		$(multilib_native_use_enable introspection)
		# python is built separately
		--disable-python
	)

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die

		python_configure() {
			mkdir -p "${BUILD_DIR}" || die
			cd "${BUILD_DIR}" || die

			ECONF_SOURCE=${S} \
			econf "${myconf[@]}" \
				--enable-python
		}

		use python && python_parallel_foreach_impl python_configure
	fi
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python; then
		local native_builddir=${BUILD_DIR}

		python_compile() {
			emake -C "${BUILD_DIR}"/python \
				VPATH="${S}/python:${native_builddir}/python" \
				igd_la_LIBADD="\$(PYGUPNP_IGD_LIBS) ${native_builddir}/libgupnp-igd/libgupnp-igd-1.0.la"
		}

		python_foreach_impl python_compile
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use python; then
		local native_builddir=${BUILD_DIR}

		python_install() {
			emake -C "${BUILD_DIR}"/python \
				VPATH="${S}/python:${native_builddir}/python" \
				DESTDIR="${D}" install
		}

		python_foreach_impl python_install
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
