# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )

inherit elisp-common gnome.org meson python-single-r1 readme.gentoo-r1

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="https://wiki.gnome.org/DocumentationProject/GtkDoc"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris"

IUSE="emacs test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6:2
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( >=app-editors/emacs-23.1:* )
	$(python_gen_cond_dep '
		dev-python/pygments[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/parameterized[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	~dev-util/gtk-doc-am-${PV}
	dev-util/itstool
	virtual/pkgconfig
"

PATCHES=(
	# Remove global Emacs keybindings, bug #184588
	"${FILESDIR}"/${PN}-1.8-emacs-keybindings.patch
)

pkg_setup() {
	DOC_CONTENTS="gtk-doc does no longer define global key bindings for Emacs.
		You may set your own key bindings for \"gtk-doc-insert\" and
		\"gtk-doc-insert-section\" in your ~/.emacs file."
	SITEFILE=61${PN}-gentoo.el
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Requires the unpackaged Python "anytree" module
	sed -i -e '/mkhtml2/d' "${S}"/tests/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dautotools_support=true
		-Dcmake_support=true
		-Dyelp_manual=true
		$(meson_use test tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	meson_src_install

	# The meson build system configures the shebangs to the temporary python
	# used during the build. We need to fix it.
	sed -i -e 's:^#!.*python3:#!/usr/bin/env python3:' "${ED}"/usr/bin/* || die
	python_fix_shebang "${ED}"/usr/bin

	# Don't install this file, it's in gtk-doc-am now
	rm "${ED}"/usr/share/aclocal/gtk-doc.m4 || die "failed to remove gtk-doc.m4"
	rmdir "${ED}"/usr/share/aclocal || die

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		readme.gentoo_create_doc
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
