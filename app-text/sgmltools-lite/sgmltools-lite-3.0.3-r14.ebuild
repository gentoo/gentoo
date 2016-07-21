# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 sgml-catalog

DESCRIPTION="Python interface to SGML software in a DocBook/OpenJade env"
HOMEPAGE="http://sgmltools-lite.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/sgmltools-lite/${P}.tar.gz
	mirror://sourceforge/sgmltools-lite/nw-eps-icons-0.0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="jadetex"

RDEPEND="${PYTHON_DEPS}
	app-text/sgml-common
	app-text/docbook-sgml-dtd:3.1
	app-text/docbook-dsssl-stylesheets
	app-text/openjade
	jadetex? ( app-text/jadetex )
	|| (
		www-client/w3m
		www-client/lynx
		)"
DEPEND=${RDEPEND}

REQUIRED_USE=${PYTHON_REQUIRED_USE}

sgml-catalog_cat_include "/etc/sgml/sgml-lite.cat" \
	"/usr/share/sgml/stylesheets/sgmltools/sgmltools.cat"

src_prepare() {
	ecvs_clean
}

src_compile() {
	default
}

src_install() {
	einstall etcdir="${D}"/etc/sgml

	dodoc ChangeLog POSTINSTALL README*
	dohtml -r .

	insinto /usr/share/sgml/docbook/dsssl-stylesheets/
	doins -r "${WORKDIR}"/nw-eps-icons-0.0.1/images

	rm "${ED}"/etc/sgml/catalog.{suse,rh62} || die

	# Remove file provided by sgml-common
	rm "${ED}"/usr/bin/sgmlwhich || die

	# List of backends to alias with sgml2*
	# Do not provide sgml2{txt,rtf,html} anymore, they are part of
	# linuxdoc-tools
	local BACKENDS=""
	if use jadetex; then
		BACKENDS="ps dvi pdf"
	else
		# Remove the backends that require jadetex
		rm "${D}"/usr/share/sgml/misc/sgmltools/python/backends/{Dvi,Ps,Pdf,JadeTeX}.py || die
	fi

	# Create simple alias scripts that people are used to
	# And make the manpages for those link to the sgmltools-lite manpage
	mandir="${D}"/usr/share/man/man1
	ScripTEXT="#!/bin/sh\n/usr/bin/sgmltools --backend="
	for back in ${BACKENDS}; do
		echo -e ${ScripTEXT}${back} '$*' > sgml2${back}
		dobin sgml2${back}

		ln -sf sgmltools-lite.1 "${mandir}/sgml2${back}.1" || die
	done

	python_fix_shebang "${D}"
	python_optimize "${ED%/}/usr/share/sgml/misc/sgmltools/python"
}

pkg_postinst() {
	sgml-catalog_pkg_postinst
}

pkg_postrm() {
	sgml-catalog_pkg_postrm
}
