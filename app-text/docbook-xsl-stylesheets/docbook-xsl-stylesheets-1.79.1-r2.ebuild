# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-single

DOCBOOKDIR="/usr/share/sgml/${PN/-//}"
MY_PN="${PN%-stylesheets}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XSL Stylesheets for Docbook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ruby"

RDEPEND="
	>=app-text/build-docbook-catalog-1.1
	ruby? ( ${RUBY_DEPS} )
"

S="${WORKDIR}/${MY_P}"

# Makefile is broken since 1.76.0
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/nonrecursive-string-subst.patch
)

src_prepare() {
	default

	# Delete the unnecessary Java-related stuff and other tools as they
	# bloat the stage3 tarballs massively. See bug #575818.
	rm -rv extensions/ tools/ || die
	find \( -name build.xml -o -name build.properties \) \
		 -printf "removed %p\n" -delete || die

	if ! use ruby; then
		rm -rv epub/ || die
	fi
}

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
	for i in */; do
		i=${i%/}

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
		cat - > "${ED%/}"/usr/bin/${cmd} <<EOF
#!/usr/bin/env ruby

load "${EPREFIX}${DOCBOOKDIR}/epub/bin/dbtoepub"
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
