# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit elisp-common gnome2 python-single-r1 readme.gentoo-r1

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="https://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~m68k ~mips ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"

IUSE="debug doc emacs pdf test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.6:2
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6:2
	dev-python/pygments[${PYTHON_USEDEP}]
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( virtual/emacs )
"
DEPEND="
	${COMMON_DEPEND}
	~dev-util/gtk-doc-am-${PV}
	dev-util/itstool
	virtual/pkgconfig
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		sys-devel/bc
		pdf? ( app-text/dblatex )
	)
"
RDEPEND="
	${COMMON_DEPEND}
	pdf? ( app-text/dblatex )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8-emacs-keybindings.patch # Remove global Emacs keybindings, bug #184588
	"${FILESDIR}"/${P}-skip-pdf-check.patch
)

pkg_setup() {
	DOC_CONTENTS="gtk-doc does no longer define global key bindings for Emacs.
		You may set your own key bindings for \"gtk-doc-insert\" and
		\"gtk-doc-insert-section\" in your ~/.emacs file."
	SITEFILE=61${PN}-gentoo.el
	python-single-r1_pkg_setup
}

src_prepare() {
	# mkhtml2 requires anytree which is not available in Gentoo
	sed -e 's/mkhtml2.py//' -i tests/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \
		$(use_enable debug)
}

src_compile() {
	gnome2_src_compile
	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	# Don't install those files, they are in gtk-doc-am now
	rm "${ED}"/usr/share/aclocal/gtk-doc.m4 || die "failed to remove gtk-doc.m4"

	# mkhtml2 requires anytree which is not available in Gentoo
	rm "${ED}"/usr/bin/gtkdoc-mkhtml2 || die "failed to remove gtk-mkhtml2"

	python_optimize "${ED}"/usr/share/gtk-doc/python/gtkdoc/

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		readme.gentoo_create_doc
	fi
}

src_test() {
	emake -j1 check
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use emacs; then
		elisp-site-regen
		readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	use emacs && elisp-site-regen
}
