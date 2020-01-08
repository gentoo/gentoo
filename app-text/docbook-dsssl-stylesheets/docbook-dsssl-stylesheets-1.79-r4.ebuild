# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit sgml-catalog-r1

MY_P=${P/-stylesheets/}
DESCRIPTION="DSSSL Stylesheets for DocBook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="https://downloads.sourceforge.net/project/docbook/docbook-dsssl/${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

RDEPEND="
	app-text/docbook-sgml-dtd:3.0
"

DOCS=( BUGS ChangeLog README RELEASE-NOTES.txt WhatsNew )

S="${WORKDIR}/${MY_P}"

src_install() {
	local d catdir=/usr/share/sgml/docbook/dsssl-stylesheets-${PV}

	dobin bin/collateindex.pl

	insinto "${catdir}"
	doins catalog VERSION

	insinto "${catdir}"/common
	doins common/*.{dsl,ent}

	insinto "${catdir}"/images
	doins images/*.gif

	for d in html lib olink print; do
		insinto "${catdir}/${d}"
		doins "${d}"/*.dsl
	done

	for d in dbdsssl html imagelib olink; do
		insinto "${catdir}/dtds/${d}"
		doins "dtds/${d}"/*.dtd
	done

	insinto "${catdir}/dtds/html"
	doins dtds/html/*.{dcl,gml}

	insinto /etc/sgml
	newins - dsssl-docbook-stylesheets.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog"
	EOF

	dodoc "${DOCS[@]}"
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/dsssl-docbook-stylesheets.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/dsssl-docbook-stylesheets.cat
	local real=${EROOT}/etc/sgml/dsssl-docbook-stylesheets.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	# this one's shared with openjade, so we need to do it in postinst
	if ! grep -q -s dsssl-docbook-stylesheets.cat \
			"${EROOT}"/etc/sgml/sgml-docbook.cat; then
		ebegin "Adding dsssl-docbook-stylesheets.cat to /etc/sgml/sgml-docbook.cat"
		cat >> "${EROOT}"/etc/sgml/sgml-docbook.cat <<-EOF
			CATALOG "${EPREFIX}/etc/sgml/dsssl-docbook-stylesheets.cat"
		EOF
		eend ${?}
	fi
	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		ebegin "Removing dsssl-docbook-stylesheets.cat from /etc/sgml/sgml-docbook.cat"
		sed -i -e '/dsssl-docbook-stylesheets/d' \
			"${EROOT}"/etc/sgml/sgml-docbook.cat
		eend ${?}
		if [[ ! -s ${EROOT}/etc/sgml/sgml-docbook.cat ]]; then
			rm -f "${EROOT}"/etc/sgml/sgml-docbook.cat
		fi
	fi
	sgml-catalog-r1_pkg_postrm
}
