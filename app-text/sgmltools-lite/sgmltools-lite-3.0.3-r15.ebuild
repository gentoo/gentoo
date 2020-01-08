# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 sgml-catalog-r1

DESCRIPTION="Python interface to SGML software in a DocBook/OpenJade env"
HOMEPAGE="http://sgmltools-lite.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz
	https://downloads.sourceforge.net/project/${PN}/support%20files/0.0.1-1/nw-eps-icons-0.0.1.tar.gz"

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

src_configure() {
	econf \
		--datadir='${prefix}/share' \
		--mandir='${prefix}/share/man'
}

src_install() {
	# yes, it does not respect DESTDIR
	emake install \
		prefix="${ED}/usr" \
		etcdir="${ED}/etc/sgml"

	dodoc ChangeLog POSTINSTALL README*

	insinto /usr/share/sgml/docbook/dsssl-stylesheets/
	doins -r "${WORKDIR}"/nw-eps-icons-0.0.1/images

	rm "${ED}"/etc/sgml/catalog.{suse,rh62} || die

	# Remove file provided by sgml-common
	rm "${ED}"/usr/bin/sgmlwhich || die

	# List of backends to alias with sgml2*
	# Do not provide sgml2{txt,rtf,html} anymore, they are part of
	# linuxdoc-tools
	local backends=()
	if use jadetex; then
		backends+=(ps dvi pdf)
	else
		# Remove the backends that require jadetex
		rm "${ED}"/usr/share/sgml/misc/sgmltools/python/backends/{Dvi,Ps,Pdf,JadeTeX}.py || die
	fi

	# Create simple alias scripts that people are used to
	# And make the manpages for those link to the sgmltools-lite manpage
	local b
	for b in "${backends[@]}"; do
		newbin - "sgml2${b}" <<-EOF
			#!/bin/sh
			exec sgmltools --backend=${b} "\${@}"
		EOF

		dosym sgmltools-lite.1 "/usr/share/man/man1/sgml2${b}.1"
	done

	insinto /etc/sgml
	newins - sgml-lite.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/stylesheets/sgmltools/sgmltools.cat"
	EOF

	python_fix_shebang "${D}"
	python_optimize "${ED}/usr/share/sgml/misc/sgmltools/python"
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/sgml-lite.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/sgml-lite.cat
	local real=${EROOT}/etc/sgml/sgml-lite.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	sgml-catalog-r1_pkg_postinst
}
