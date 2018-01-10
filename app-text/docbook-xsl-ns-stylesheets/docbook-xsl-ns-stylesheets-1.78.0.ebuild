# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DOCBOOKDIR="/usr/share/sgml/${PN/-//}"
MY_PN="${PN%-stylesheets}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XSL Stylesheets for Docbook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="ruby"

RDEPEND=">=app-text/build-docbook-catalog-1.4
	ruby? ( dev-lang/ruby )"
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
