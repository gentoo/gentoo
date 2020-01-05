# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT=( python{3_6,3_7} )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit gnome.org distutils-r1

DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
"

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"

python_prepare_all() {
	PATCHES=(
		"${FILESDIR}/${PN}-2.56.1-sitedir.patch"
	)
	distutils-r1_python_prepare_all

	sed -e 's:@PYTHON@:python:' gdbus-codegen.in > gdbus-codegen || die
	sed -e "s:@VERSION@:${PV}:" config.py.in > config.py || die
	cp "${FILESDIR}/setup.py-2.32.4" setup.py || die "cp failed"
	sed -e "s/@PV@/${PV}/" -i setup.py || die "sed setup.py failed"
}

do_xsltproc_command() {
	# Taken from meson.build for manual manpage building - keep in sync (also copied to dev-util/glib-utils)
	xsltproc \
		--nonet \
		--stringparam man.output.quietly 1 \
		--stringparam funcsynopsis.style ansi \
		--stringparam man.th.extra1.suppress 1 \
		--stringparam man.authors.section.enabled 0 \
		--stringparam man.copyright.section.enabled 0 \
		-o "${2}" \
		http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl \
		"${1}" || die "manpage generation failed"
}

src_compile() {
	distutils-r1_src_compile
	do_xsltproc_command "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.xml" "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1"
}

src_test() {
	einfo "Skipping tests. This package is tested by dev-libs/glib"
	einfo "when merged with FEATURES=test"
}

python_install_all() {
	distutils-r1_python_install_all # no-op, but prevents QA warning
	doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1"
}
