# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DOCBOOKDIR="/usr/share/sgml/${PN/-//}"
MY_PN="${PN%-stylesheets}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XSL Stylesheets for Docbook"
HOMEPAGE="http://wiki.docbook.org/DocBookXslStylesheets"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ruby"

RDEPEND=">=app-text/build-docbook-catalog-1.1
ruby? ( || ( dev-lang/ruby:1.9 dev-lang/ruby:2.0 dev-lang/ruby:2.1 dev-lang/ruby:2.2 ) )"
DEPEND=""

S="${WORKDIR}/${MY_P}"

# Makefile is broken since 1.76.0
RESTRICT=test

# The makefile runs tests, not builds.
src_compile() { :; }

src_test() {
	emake check
}

src_install() {
	# The changelog is now zipped, and copied as the RELEASE-NOTES, so we
	# don't need to install it
	dodoc AUTHORS BUGS NEWS README RELEASE-NOTES.txt TODO

	insinto ${DOCBOOKDIR}
	doins VERSION VERSION.xsl

	local i
	for i in $(find . -maxdepth 1 -mindepth 1 -type d -exec basename {} \;); do
		[[ "$i" == "epub" ]] && ! use ruby && continue

		cd "${S}"/${i}
		for doc in ChangeLog README; do
			if [ -e "$doc" ]; then
				mv ${doc} ${doc}.${i}
				dodoc ${doc}.${i}
				rm ${doc}.${i}
			fi
		done

		doins -r "${S}"/${i}
	done

	if use ruby; then
		local cmd="dbtoepub${MY_PN#docbook-xsl}"

		# we can't use a symlink or it'll look for the library in the
		# wrong path.
		dodir /usr/bin
		cat - > "${D}"/usr/bin/${cmd} <<EOF
#!/usr/bin/env ruby

load "${DOCBOOKDIR}/epub/bin/dbtoepub"
EOF
		fperms 0755 /usr/bin/${cmd}
	fi
}

pkg_postinst() {
	build-docbook-catalog
}

pkg_postrm() {
	build-docbook-catalog
}
