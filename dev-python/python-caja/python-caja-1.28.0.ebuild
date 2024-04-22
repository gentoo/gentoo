# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

PYTHON_COMPAT=( python3_{9..11} )

inherit mate python-single-r1

if [[ "${PV}" != *9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Python bindings for the Caja file manager"
LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.50:2
	$( python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]' )
	>=mate-base/caja-1.17.1[introspection]
	>=x11-libs/gtk+-3.22:3
"
BDEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	doc? ( app-text/docbook-xml-dtd:4.1.2 )
"

src_prepare() {
	MATE_FORCE_AUTORECONF="true"

	sed -i "s/\$(PACKAGE)/${PF}/g" examples/Makefile.am || die
	mate_src_prepare
}

src_install() {
	mate_src_install

	# Keep the directory for systemwide extensions.
	keepdir /usr/share/caja-python/extensions/

	# The HTML documentation generation is broken and commented out by upstream.
	#
	#if use doc ; then
	#	insinto /usr/share/gtk-doc/html/nautilus-python # for dev-util/devhelp
	#	doins -r docs/html/*
	#fi
}
